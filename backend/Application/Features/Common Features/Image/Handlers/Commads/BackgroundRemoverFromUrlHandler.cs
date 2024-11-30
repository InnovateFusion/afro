using backend.Application.Features.Common_Features.Image.Requests.Commands;
using MediatR;
using IImageRepository = backend.Application.Contracts.Infrastructure.Repositories.IImageRepository;

namespace backend.Application.Features.Common_Features.Image.Handlers.Commads;

public class BackgroundRemoverFromUrlHandler(
    IImageRepository imageRepository)
    : IRequestHandler<BackgroundRemoverFromUrlRequest, Stream>
{
    public async Task<Stream> Handle(BackgroundRemoverFromUrlRequest request, CancellationToken cancellationToken)
    {
       return  await imageRepository.RemoveBackgroundFromUrlAsync(request.ImageUrl);
    }
}