using backend.Application.Enum;

namespace backend.Application.DTO.Product.ColorDTO.DTO
{
    public class ColorResponseDTO
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
        public required string HexCode { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
    }
}
