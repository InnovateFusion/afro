using backend.Application.DTO.Common.Image.DTO;

namespace backend.Application.Contracts.Infrastructure.Repositories
{
    public interface IImageRepository
    {
        Task<string> Upload(string base64Image, string publicId, bool backgroundRemoval = false);
        Task<string> Update(string base64Image, string publicId, bool backgroundRemoval = false);
        Task<bool> Delete(string publicId);
        Task<Stream> RemoveBackgroundAsync(ImageFileUploadDto imageModel);
        Task<Stream> RemoveBackgroundFromUrlAsync(string imageUrl);
        
    }
}
