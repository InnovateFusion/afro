using backend.Application.DTO.Common.Image.DTO;
using MediatR;

namespace backend.Application.Features.Common_Features.Image.Requests.Commands;

public class BackgroundRemoverRequest: IRequest<Stream>
{
    public ImageFileUploadDto Image { get; set; }
}