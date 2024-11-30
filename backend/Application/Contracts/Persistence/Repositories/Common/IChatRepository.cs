using backend.Application.DTO.Common.Chat.DTO;
using backend.Domain.Entities.Common;

namespace backend.Application.Contracts.Persistence.Repositories.Common;
public interface IChatRepository: IGenericRepository<Chat>
{
    Task<IReadOnlyList<Chat>> GetAll(string senderId, string receiverId, int skip, int take);
    Task<Chat> GetById(string id);
    Task<IReadOnlyList<Domain.Entities.User.User>> GetUsersChat(string userId, int skip, int take);
    Task<IReadOnlyList<UserChatDto>> GetUsersChatWithLastMessage(string userId, int skip, int take);
    Task<int> MarkChatsAsRead(string chatId);
}