using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Queries;

public class GetUsersChatWithLastMessageHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetUsersChatWithLastMessageRequests, List<UserChatDtoResponse>>
{
    public async Task<List<UserChatDtoResponse>> Handle(GetUsersChatWithLastMessageRequests request, CancellationToken cancellationToken)
    {
        var users = await unitOfWork.ChatRepository.GetUsersChatWithLastMessage(
            request.UserId,
            request.Skip,
            request.Take
        );
        var userResponse = mapper.Map<List<UserChatDtoResponse>>(users);
        return userResponse;
    }
}
