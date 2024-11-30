using backend.Application.DTO.Common.Image.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Image.Requests.Commands;

public class BackgroundRemoverFromUrlRequest: IRequest<Stream>
{
    public required String ImageUrl { get; set; }
}