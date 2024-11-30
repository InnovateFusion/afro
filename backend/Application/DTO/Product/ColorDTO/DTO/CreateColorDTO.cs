using backend.Application.Enum;

namespace backend.Application.DTO.Product.ColorDTO.DTO
{
    public class CreateColorDTO
    {
        public required string Name { get; set; }
        public required string HexCode { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
    }
}