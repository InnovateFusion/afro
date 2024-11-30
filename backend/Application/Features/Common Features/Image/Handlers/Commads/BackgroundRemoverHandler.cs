using backend.Application.Features.Common_Features.Image.Requests.Commands;
using MediatR;
using IImageRepository = backend.Application.Contracts.Infrastructure.Repositories.IImageRepository;

namespace backend.Application.Features.Common_Features.Image.Handlers.Commads;

public class BackgroundRemoverHandler(
    IImageRepository imageRepository)
    : IRequestHandler<BackgroundRemoverRequest, Stream>
{
    public async Task<Stream> Handle(BackgroundRemoverRequest request, CancellationToken cancellationToken)
    {
       return  await imageRepository.RemoveBackgroundAsync(request.Image);
    }
}