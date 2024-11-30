namespace backend.Infrastructure.Models;

public class JwtSettings
{
    public const string SessionName = "JwtSettings";
    public string? Key { get; set; }
    public string? Issuer { get; set; }
    public string? Audience { get; set; }
    public int DurationInMinutes { get; set; } = 60 * 24 * 7;
    public int RefreshTokenExpirationInMinutes { get; set; } = 60 * 24 * 7 * 4;
}
