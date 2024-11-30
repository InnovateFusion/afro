namespace backend.Infrastructure.Models;

public class TikTokSettings
{
    public string? ClientId { get; set; }
    public string? ClientSecret { get; set; }
    public string? RedirectUri { get; set; }
    public string? CodeVerifier { get; set; }
}