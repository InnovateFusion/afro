using backend.Application.Enum;

namespace backend.Application.DTO.Product.BrandDTO.DTO
{
    public class BrandResponseDTO
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
    }
}
