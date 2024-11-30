using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Application.Enum;
using backend.Domain.Common;

namespace backend.Domain.Entities.Shop;

public class Shop: BaseEntity
{
    public required string Name { get; set; }
    public required string Description { get; set; }
    public required string Category { get; set; }
    public required string Street { get; set; }
    public required string SubLocality { get; set; }
    public required string SubAdministrativeArea { get; set; }
    public required string PostalCode { get; set; }
    public required double Latitude { get; set; }
    public required double Longitude { get; set; }
    public required string PhoneNumber { get; set; }
    public string? Banner { get; set; }
    public string Logo { get; set; } = string.Empty;
    public string SocialMedias { get; set; } = string.Empty;
    public int VerificationStatus { get; set; } = 0;
    public int PremiumType { get; set; } = 0;
    public bool Active { get; set; } = false;
    public DateTime LastSeenAt { get; set; } = DateTime.Now;
    public string? Website { get; set; }
    public required User.User Owner { get; set; }
    [Required]
    [ForeignKey(nameof(Owner))]
    public required string UserId { get; set; }
    public string OwnerIdentityCardUrl { get; set; } = string.Empty;
    public string BusinessRegistrationNumber { get; set; } = string.Empty;
    public string BusinessRegistrationDocumentUrl { get; set; } = string.Empty;
    public string OwnerSelfieUrl { get; set; } = string.Empty;
    public DateTime? VerifiedAt { get; set; }
    public virtual HashSet<ShopReview> ShopReviews { get; set; } = new HashSet<ShopReview>();
    public virtual HashSet<WorkingHour> WorkingHours { get; set; } = new HashSet<WorkingHour>();
    public virtual HashSet<Product.Product> Products { get; set; } = new HashSet<Product.Product>();
    public required bool IsDeleted { get; set; } = false;
    
    public DateTime DeletedAt { get; set; }
    
    public override string ToString()
    {
        return $"Id: {Id}, Name: {Name}, Description: {Description}, Category: {Category}, Street: {Street}, SubLocality: {SubLocality}, SubAdministrativeArea: {SubAdministrativeArea}, PostalCode: {PostalCode}, Latitude: {Latitude}, Longitude: {Longitude}, PhoneNumber: {PhoneNumber}, Banner: {Banner}, Logo: {Logo}, SocialMedias: {SocialMedias}, VerificationStatus: {VerificationStatus}, PremiumType: {PremiumType}, Active: {Active}, LastSeenAt: {LastSeenAt}, Website: {Website}, UserId: {UserId}, OwnerIdentityCardUrl: {OwnerIdentityCardUrl}, BusinessRegistrationNumber: {BusinessRegistrationNumber}, BusinessRegistrationDocumentUrl: {BusinessRegistrationDocumentUrl}, VerifiedAt: {VerifiedAt}";
    }
}