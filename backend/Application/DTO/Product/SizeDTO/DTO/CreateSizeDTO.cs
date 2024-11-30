using backend.Application.Enum;

namespace backend.Application.DTO.Product.SizeDTO.DTO
{
    public class CreateSizeDTO
    {
        public required string Name { get; set; }
        public required string Abbreviation { get; set; }
        
        public ParentFilterType ParentFilterType { get; set; } 
    }
}
