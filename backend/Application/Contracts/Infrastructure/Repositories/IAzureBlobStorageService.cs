namespace backend.Application.Contracts.Infrastructure.Repositories;

public interface IAzureBlobStorageService
{

   Task<string> UploadImageAsync(byte[] imageBytes, string fileName);
   
   Task<string> UpdateImageAsync(byte[] imageBytes, string fileName);

   Task<List<string>> ListBlobsAsync();

   Task DownloadImageAsync(string blobName, string downloadFilePath);
   
   Task DeleteBlobAsync(string blobName);
}