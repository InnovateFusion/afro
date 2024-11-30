using System.Security.Claims;
using backend.Application.DTO.Common.Notification.DTO;
using backend.Application.Features.Common_Features.Notification.Requests.Commands;
using backend.Application.Features.Common_Features.Notification.Requests.Queries;
using MediatR;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNetCore.Mvc;

namespace backend.WebApi.Controllers.Common;

[ApiController]
[Route("api/[controller]")]
public class NotificationController(IMediator mediator) : ControllerBase
{
    [HttpGet("{id}")]
    public async Task<ActionResult<NotificationResponseDto>> GetNotificationById(string id)
    {
        var result = await mediator.Send(new GetNotificationByIdRequest { Id = id });
        return Ok(result);
    }
    
    [HttpGet("User")]
    [Authorize]
    public async Task<ActionResult<List<NotificationResponseDto>>> GetNotificationForUser([FromQuery] int skip = 0,
        [FromQuery] int take = 15)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new GetNotificationForUserRequest {  UserId = userId!, Skip = skip, Limit = take });
        return Ok(result);
    }
    
    [HttpDelete("{id}")]
    [Authorize(Roles = "admin")]
    public async Task<ActionResult<NotificationResponseDto>> DeleteNotification(string id)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new DeleteNotificationRequest { UserId = userId!, Id = id });
        return Ok(result);
    }
    
    [HttpPost]
    [Authorize(Roles = "admin")]
    public async Task<ActionResult<NotificationResponseDto>> CreateNotification(CreateNotificationDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new CreateNotificationRequest { SenderId = userId!, Notification = dto });
        return Ok(result);
    }
    
    [HttpPut]
    [Authorize(Roles = "admin")]
    public async Task<ActionResult<NotificationResponseDto>> UpdateNotification(UpdateNotificationDto dto)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new UpdateNotificationRequest { SenderId = userId!, Notification = dto });
        return Ok(result);
    }
    
    [HttpGet("MarkAsRead")]
    [Authorize]
    public async Task<ActionResult<NotificationResponseDto>> MarkAsRead()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        var result = await mediator.Send(new MarkNotificationAsReadRequest { UserId = userId!});
        return Ok(result);
    }
}