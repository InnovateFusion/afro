using backend.Application.Contracts.Persistence.Repositories.Common;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Domain.Entities.Common;
using backend.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;

namespace backend.Persistence.Repositories.Common;

public class ChatRepository(StyleHubDBContext context): GenericRepository<Chat>(context), IChatRepository
{
    public async Task<IReadOnlyList<Chat>> GetAll(string senderId, string receiverId, int skip, int take)
    {
        var chats = await context.Chats
            .Where(u => 
                (u.SenderId == senderId && u.ReceiverId == receiverId) ||
                (u.SenderId == receiverId && u.ReceiverId == senderId))
            .OrderByDescending(u => u.CreatedAt)
            .Skip(skip)
            .Take(take)
            .ToListAsync();
        return chats;
    }
    
    public async Task<Chat> GetById(string id)
    {
        var chat = await context.Chats
            .FirstOrDefaultAsync(u => u.Id == id);
        return chat!;
    }

    public async Task<IReadOnlyList<Domain.Entities.User.User>> GetUsersChat(string userId, int skip, int take)
    {
        var chats = await context.Chats
            .Where(c => c.SenderId == userId || c.ReceiverId == userId)
            .ToListAsync();
        
        var userIds = chats
            .GroupBy(c => c.SenderId == userId ? c.ReceiverId : c.SenderId)
            .Select(g => new
            {
                UserId = g.Key,
                LastMessageTimestamp = g.Max(c => c.CreatedAt)
            })
            .OrderByDescending(u => u.LastMessageTimestamp)
            .Skip(skip)
            .Take(take)
            .Select(u => u.UserId)
            .ToList();
        
        var users = await context.Users
            .Where(u => userIds.Contains(u.Id))
            .ToListAsync();

        return users;
    }
    
    public async Task<IReadOnlyList<UserChatDto>> GetUsersChatWithLastMessage(string userId, int skip, int take)
    {
        // Get the chats involving the user
        var chats = await context.Chats
            .Where(c => c.SenderId == userId || c.ReceiverId == userId)
            .OrderByDescending( c => c.CreatedAt)
            .ToListAsync();
        
        var userLastMessages = chats
            .GroupBy(c => c.SenderId == userId ? c.ReceiverId : c.SenderId)
            .Select(g => new
            {
                UserId = g.Key,
                LastMessage = g.OrderByDescending(c => c.CreatedAt).FirstOrDefault()
            })
            .OrderByDescending(u => u.LastMessage!.CreatedAt)
            .Skip(skip)
            .Take(take)
            .ToList();
    
        var userIds = userLastMessages.Select(u => u.UserId).ToList();
        
        var users = await context.Users
            .Where(u => userIds.Contains(u.Id))
            .ToListAsync();
        
        var userChatDtos = users.Select(u => new UserChatDto
        {
            User = u,
            LastMessage = userLastMessages.First(ul => ul.UserId == u.Id).LastMessage
        }).ToList();
        
        return userChatDtos;
    }

    public async Task<int> MarkChatsAsRead(string chatId)
    {
        var chats = await context.Chats
            .Where(c => c.Id == chatId)
            .ToListAsync();
        
        foreach (var chat in chats)
        {
            chat.IsRead = true;
        }
        return await context.SaveChangesAsync();
    }
}