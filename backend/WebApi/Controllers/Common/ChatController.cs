using System.Security.Claims;
using backend.Application.DTO.Common.Chat.DTO;
using backend.Application.DTO.User.UserDTO.DTO;
using backend.Application.Features.Common_Features.Chat.Requests.Commads;
using backend.Application.Features.Common_Features.Chat.Requests.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace backend.WebApi.Controllers.Common;

[ApiController]
[Route("api/[controller]")]
public class ChatController(IMediator mediator) : ControllerBase
{
    [HttpGet("Between/{receiverId}")]
    [Authorize]
    public async Task<ActionResult<List<ChatResponseDTO>>> FetchAllChats(string receiverId, [FromQuery] int skip = 0,
        [FromQuery] int limit = 30)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        var result = await mediator.Send(new GetAllChatBetweenSenderAndReceiveById
        {
            SenderId = userId!,
            ReceiverId = receiverId,
            Skip = skip,
            Take = limit
        });
        return Ok(result);
    }

    [HttpGet("{id}")]
    [Authorize]
    public async Task<ActionResult<ChatResponseDTO>> FetchChatById(string id)
    {
        var result = await mediator.Send(new GetChatById { Id = id });
        return Ok(result);
    }

    [HttpPost]
    [Authorize]
    public async Task<ActionResult<ChatResponseDTO>> CreateChat([FromBody] CreateChatDTO dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new CreateChatRequest
        {
            SenderId = userId!,
            Chat = dto
        });
        return Ok(result);
    }

    [HttpDelete("{id}")]
    [Authorize]
    public async Task<ActionResult<ChatResponseDTO>> DeleteChat(string id)
    {
        var result = await mediator.Send(new DeleteChatByIdRequest { Id = id });
        return Ok(result);
    }

    [HttpGet("Users")]
    [Authorize]
    public async Task<ActionResult<UserResponseDTO>> FetchUsersChat([FromQuery] int skip = 0, [FromQuery] int take = 15)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new GetUsersChatWithRequests
        {
            UserId = userId!,
            Skip = skip,
            Take = take
        });
        return Ok(result);
    }
    
    [HttpGet("Users/LastMessage")]
    [Authorize]
    public async Task<ActionResult<UserResponseDTO>> FetchUsersChatWithLastMessage([FromQuery] int skip = 0, [FromQuery] int take = 15)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new GetUsersChatWithLastMessageRequests
        {
            UserId = userId!,
            Skip = skip,
            Take = take
        });
        return Ok(result);
    }

    [HttpGet("MarkRead/{chatId}/sender/{senderId}")]
    [Authorize]
    public async Task<ActionResult<UserResponseDTO>> MarkChatAsRead(string chatId, string senderId)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new MarkChatsAsReadRequest
        {
            ChatId = chatId,
            SenderId = senderId,
            ReceiverId = userId!
        });
        return Ok(result);
    }
   
}