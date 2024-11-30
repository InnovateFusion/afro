using backend.Application.Enum;

namespace backend.Application.DTO.Product.BrandDTO.DTO
{
    public class CreateBrandDTO
    {
        public required string Name { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
    }
}
