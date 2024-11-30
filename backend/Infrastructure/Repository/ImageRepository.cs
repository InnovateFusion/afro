using backend.Application.Contracts.Infrastructure.Repositories;
using System.Net.Http.Headers;
using backend.Application.DTO.Common.Image.DTO;
using backend.Application.Exceptions;
using backend.Infrastructure.Models;
using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Microsoft.Extensions.Options;

namespace backend.Infrastructure.Repository
{
    public class ImageRepository(Cloudinary cloudinary, HttpClient httpClient, IOptions<BlobStorageSettings> blobStorageSettings) : IImageRepository
    {
        public async Task<bool> Delete(string publicId)
        {
            try
            {
                var deletionParams = new DeletionParams(publicId);

                var deletionResult = await cloudinary.DestroyAsync(deletionParams);

                if (deletionResult != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception)
            {
                return false;
            }
        }

     
        public async Task<Stream> RemoveBackgroundAsync(ImageFileUploadDto imageModel)
        {
            if (imageModel.Image == null || imageModel.Image.Length == 0)
            {
                throw new ArgumentException("Image file is required.");
            }

            try
            {
                var url = blobStorageSettings.Value.ImageBackgroundRemoverUrl ?? "";
                url += "remove-background";
                var request = new HttpRequestMessage(System.Net.Http.HttpMethod.Post, url);
                var formData = new MultipartFormDataContent();
                var imageContent = new StreamContent(imageModel.Image.OpenReadStream());
                imageContent.Headers.ContentType = MediaTypeHeaderValue.Parse(imageModel.Image.ContentType);
                formData.Add(imageContent, "image", imageModel.Image.FileName);
                request.Content = formData;

                var response = await httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadAsStreamAsync();
                }
                else
                {
                    throw new HttpRequestException($"Error from Python API: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<Stream> RemoveBackgroundFromUrlAsync(string imageUrl)
        {
            if (string.IsNullOrEmpty(imageUrl))
            {
                throw new ArgumentException("Image URL is required.");
            }

            try
            {
                var url = blobStorageSettings.Value.ImageBackgroundRemoverUrl ?? "";
                url += "remove-background-from-url";
                var request = new HttpRequestMessage(System.Net.Http.HttpMethod.Post, url);
        
                var jsonContent = new StringContent(
                    $"{{\"url\": \"{imageUrl}\"}}",
                    System.Text.Encoding.UTF8,
                    "application/json"
                );
                request.Content = jsonContent;

                var response = await httpClient.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadAsStreamAsync();
                }
                else
                {
                    throw new HttpRequestException($"Error from Python API: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        
        public async Task<string> Update(
            string base64Image,
            string publicId,
            bool backgroundRemoval = false
        )
        {
            var uploadParams = new ImageUploadParams
            {
                File = new FileDescription(@$"{base64Image}"),
                PublicId = publicId,
                BackgroundRemoval = backgroundRemoval ? "cloudinary_ai" : null,
            };

            var uploadResult = await cloudinary.UploadAsync(uploadParams);

            if (uploadResult != null)
            {
                if (uploadResult.SecureUrl != null)
                {
                    return uploadResult.SecureUrl.ToString();
                }

                if (uploadResult.Error != null)
                {
                    throw new BadRequestException(uploadResult.Error.Message);
                }

                throw new BadRequestException("Upload result is null");
            }
            else
            {
                throw new BadRequestException("Upload result is null");
            }
        }

        public async Task<string> Upload(
            string base64Image,
            string publicId,
            bool backgroundRemoval = false
        )
        {
            var uploadParams = new ImageUploadParams
            {
                File = new FileDescription(@$"{base64Image}"),
                PublicId = publicId,
                BackgroundRemoval = backgroundRemoval ? "cloudinary_ai" : null,
            };

            var uploadResult = await cloudinary.UploadAsync(uploadParams);

            if (uploadResult != null)
            {
                if (uploadResult.SecureUrl != null)
                {
                    return uploadResult.SecureUrl.ToString();
                }

                if (uploadResult.Error != null)
                {
                    throw new BadRequestException(uploadResult.Error.Message);
                }

                throw new BadRequestException("Upload result is null");
            }
            else
            {
                throw new BadRequestException("Upload result is null");
            }
        }
    }
}
