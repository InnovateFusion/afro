using AutoMapper;
using backend.Application.Contracts.Infrastructure.Services;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Product.ProductDTO.DTO;
using backend.Application.Enum;
using backend.Application.Exceptions;
using backend.Application.Features.Product_Features.Product.Requests.Commands;
using backend.Application.Response;
using backend.Domain.Entities.Common;
using MediatR;

namespace backend.Application.Features.Product_Features.Product.Handlers.Commands;

public class ProductApprovalHandler(IUnitOfWork unitOfWork, IMapper mapper, IRabbitMQService rabbitMqService)
    : IRequestHandler<ProductApproval, BaseResponse<ProductResponseDTO>>
{
    public async Task<BaseResponse<ProductResponseDTO>> Handle(ProductApproval request, CancellationToken cancellationToken)
    {
        var product = await unitOfWork.ProductRepository.GetById(request.ProductId);
        
        if (product == null)
            throw new BadRequestException("Product does not exist");
        string approvalMessage = "Your product has been approved.";
        string rejectionMessage = "Your product has been rejected due to inappropriate content.";
        string policyCheckMessage = "Please check your content: ensure the image, title, and description comply with our policy.";
        string message = "";

        if (product.ProductApprovalStatus == request.ProductApprovalStatusId)
        {
            return new BaseResponse<ProductResponseDTO>
            {
                Message = "Product Created Successfully",
                Success = true,
                Data = mapper.Map<ProductResponseDTO>(product)
            };
        }
        
        if (request.ProductApprovalStatusId == (int)ProductApprovalStatus.Approved)
        {
            product.ProductApprovalStatus = (int)ProductApprovalStatus.Approved;
            message = approvalMessage;
        }else if (request.ProductApprovalStatusId == (int)ProductApprovalStatus.Rejected)
        {
            product.ProductApprovalStatus = (int)ProductApprovalStatus.Rejected;
            message = $"{rejectionMessage} {policyCheckMessage}";
        }
        else
        {
            throw new BadRequestException("Invalid product approval status");
        }

        if (product.ProductApprovalStatus ==  (int)ProductApprovalStatus.Approved)
        {
            rabbitMqService.PublishMessageAsync("notification-shop", "notification-shop", "notification-shop", new Notification
            {
                TypeId = product.Id,
                Message = "Shop added new product",
                SenderId = product.ShopId,
                ReceiverId = product.ShopId,
                Type = (int)NotificationType.AddProduct,
                MessageType = 1,
            }.ToJson());
        }
        
        var notification = new Notification
        {
            TypeId = product.Id,
            Message = message,
            SenderId = request.UserId,
            ReceiverId = product.ShopId,
            IsAdmin = true,
            Type = (int)NotificationType.Verify,
            MessageType = 2,
        };
        
        rabbitMqService.PublishMessageAsync("notification", "notification", "notification",  new Notification
        {
            TypeId = notification.TypeId,
            Message = notification.Message,
            SenderId = notification.SenderId,
            ReceiverId = notification.ReceiverId,
            MessageType = notification.MessageType,
            Type = notification.Type
        }.ToJson());
        
        product = await unitOfWork.ProductRepository.Update(product);
        await unitOfWork.NotificationRepository.Add(notification);
        
        return new BaseResponse<ProductResponseDTO>
        {
            Message = "Product Created Successfully",
            Success = true,
            Data = mapper.Map<ProductResponseDTO>(product)
        };
    }
}