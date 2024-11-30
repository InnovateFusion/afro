using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using backend.Application.Contracts.Infrastructure.Repositories;
using backend.Infrastructure.Models;
using Microsoft.Extensions.Options;
namespace backend.Infrastructure.Repository;

public class AzureBlobStorageService: IAzureBlobStorageService
{
    private readonly BlobServiceClient _blobServiceClient;
    private readonly string _containerName;
    
    public AzureBlobStorageService(IOptions<BlobStorageSettings> blobStorageSettings)
    {
        string connectionString = blobStorageSettings.Value.ConnectionString ?? "";
        _containerName = blobStorageSettings.Value.ContainerName ?? "";
        _blobServiceClient = new BlobServiceClient(connectionString);
    }
    
    public async Task<string> UploadImageAsync(byte[] imageBytes, string fileName)
    {
        BlobContainerClient containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
        await containerClient.CreateIfNotExistsAsync(PublicAccessType.Blob);

        BlobClient blobClient = containerClient.GetBlobClient(fileName);
        
        var httpHeaders = new BlobHttpHeaders
        {
            ContentType = "image/png" 
        };

        using (var stream = new MemoryStream(imageBytes))
        {
            await blobClient.UploadAsync(stream, new BlobUploadOptions
            {
                HttpHeaders = httpHeaders
            });
        }
        return blobClient.Uri.ToString();
    }
    
    public async Task<string> UpdateImageAsync(byte[] imageBytes, string fileName)
    {
        BlobContainerClient containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
        await containerClient.CreateIfNotExistsAsync(PublicAccessType.Blob);

        BlobClient blobClient = containerClient.GetBlobClient(fileName);
        
        var httpHeaders = new BlobHttpHeaders
        {
            ContentType = "image/png" 
        };
        
        if (await blobClient.ExistsAsync())
        {
            await blobClient.DeleteAsync();
        }

        using (var stream = new MemoryStream(imageBytes))
        {
            await blobClient.UploadAsync(stream, new BlobUploadOptions
            {
                HttpHeaders = httpHeaders
            });
        }
        return blobClient.Uri.ToString();
    }

    
    public async Task<List<string>> ListBlobsAsync()
    {
        var blobUrls = new List<string>();
        BlobContainerClient containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);

        await foreach (BlobItem blobItem in containerClient.GetBlobsAsync())
        {
            BlobClient blobClient = containerClient.GetBlobClient(blobItem.Name);
            blobUrls.Add(blobClient.Uri.ToString());
        }

        return blobUrls;
    }
    
    public async Task DownloadImageAsync(string blobName, string downloadFilePath)
    {
        BlobContainerClient containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
        BlobClient blobClient = containerClient.GetBlobClient(blobName);

        await blobClient.DownloadToAsync(downloadFilePath);
    }

    public async Task DeleteBlobAsync(string blobName)
    {
        BlobContainerClient containerClient = _blobServiceClient.GetBlobContainerClient(_containerName);
        BlobClient blobClient = containerClient.GetBlobClient(blobName);

        await blobClient.DeleteAsync();
    }
    
}