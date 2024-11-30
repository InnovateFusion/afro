using backend.Application.DTO.Shop.ShopDTO.DTO;
using backend.Application.Enum;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Requests.Queries;

public class GetAllShopRequest(
    string? userId = null,
    string? search = null,
    List<string>? category = null,
    List<WorkingHourQueryParamater>? workingHours = null,
    double? radiusInKilometers = null,
    double? latitude = null,
    double? longitude = null,
    int? rating = null,
    ShopVerificationStatus? verified = null,
    bool? active = null,
    string? ownerId = null,
    string? sortBy = null,
    string? sortOrder = null,
    int skip = 0,
    int limit = 10
    ): IRequest<List<ShopResponseDTO>>
{
    public string? UserId { get; set; } = userId;
    public string? Search { get; set; } = search;
    public List<string>? Category { get; set; } = category;
    public List<WorkingHourQueryParamater>? WorkingHours { get; set; } = workingHours;
    public double? RadiusInKilometers { get; set; } = radiusInKilometers;
    public double? Latitude { get; set; } = latitude;
    public double? Longitude { get; set; } = longitude;
    public int? Rating { get; set; } = rating;
    public ShopVerificationStatus? Verified { get; set; } = verified;
    public bool? Active { get; set; } = active;
    public string? OwnerId { get; set; } = ownerId;
    public string? SortBy { get; set; } = sortBy;
    public string? SortOrder { get; set; } = sortOrder;
    public int Skip { get; set; } = skip;
    public int Limit { get; set; } = limit;
}