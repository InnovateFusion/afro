namespace backend.Application.DTO.Shop.ShopDTO.DTO;

public class ShopVerifyRequestDto
{
    public required string Id { get; set; }
    public required string OwnerIdentityCardUrl { get; set; }
    public required string BusinessRegistrationNumber { get; set; }
    public required string BusinessRegistrationDocumentUrl { get; set; }
    public required string OwnerSelfieUrl { get; set; }
}