using backend.Application.Enum;

namespace backend.Application.DTO.Product.MaterialDTO.DTO
{
    public class MaterialResponseDTO : IBaseMaterialDTO
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 

    }
}