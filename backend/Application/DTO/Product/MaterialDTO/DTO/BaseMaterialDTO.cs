using backend.Application.Enum;

namespace backend.Application.DTO.Product.MaterialDTO.DTO
{
    public class BaseMaterialDTO : IBaseMaterialDTO
    {
        public required string Name { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
    }
}