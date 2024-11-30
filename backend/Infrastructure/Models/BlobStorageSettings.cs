namespace backend.Infrastructure.Models
{
    public class BlobStorageSettings
    {
        public string? ConnectionString { get; set; }
        public string? ContainerName { get; set; }
        public string? BlobUrl { get; set; }
        public string? ImageBackgroundRemoverUrl { get; set; }
    }
}
