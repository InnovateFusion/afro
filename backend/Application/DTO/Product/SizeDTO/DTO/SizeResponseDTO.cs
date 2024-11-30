using backend.Application.Enum;

namespace backend.Application.DTO.Product.SizeDTO.DTO
{
    public class SizeResponseDTO
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
        public required string Abbreviation { get; set; }
        
        public ParentFilterType ParentFilterType { get; set; } 
    }
}
