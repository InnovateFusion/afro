using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Exceptions;
using backend.Application.Features.Common_Features.Notification.Requests.Commands;
using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Common_Features.Notification.Handlers.Commands;

public class UpdateNotificationHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<UpdateNotificationRequest, BaseResponse<NotificationResponseDto>>
{
    public async Task<BaseResponse<NotificationResponseDto>> Handle(UpdateNotificationRequest request, CancellationToken cancellationToken)
    {
        var notification = await unitOfWork.NotificationRepository.GetById(request.Notification.Id);
        if (notification == null)
        {
            throw new NotFoundException("Notification Not Found");
        }
        
        if (notification.Sender.Id != request.SenderId)
        {
            throw new BadRequestException("You are not the sender of this notification");
        }
        
        
        if (!string.IsNullOrEmpty(request.Notification.Message))
        {
            notification.Message = request.Notification.Message;
        }
        
        await unitOfWork.NotificationRepository.Update(notification);
        
        return new BaseResponse<NotificationResponseDto>
        {
            Message = "Notification Updated Successfully",
            Success = true,
            Data = mapper.Map<NotificationResponseDto>(notification)
        };
    }
}