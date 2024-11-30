using AutoMapper;
using backend.Application.Contracts.Persistence;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;

namespace backend.Application.Features.Common_Features.Chat.Handlers.Queries;

public class GetUsersChatWithHandler(IUnitOfWork unitOfWork, IMapper mapper)
    : IRequestHandler<GetUsersChatWithRequests, List<UserResponseDTO>>
{
    public async Task<List<UserResponseDTO>> Handle(GetUsersChatWithRequests request, CancellationToken cancellationToken)
    {
        var users = await unitOfWork.ChatRepository.GetUsersChat(
            request.UserId,
            request.Skip,
            request.Take
        );
        var userResponse = mapper.Map<List<UserResponseDTO>>(users);
        return userResponse;
    }
}
