using backend.Application.Enum;

namespace backend.Application.DTO.Product.DesignDTO.DTO;
public class DesignResponseDTO
{ 
        public required string Id { get; set; } 
        public required string Name { get; set; }
        public ParentFilterType ParentFilterType { get; set; } 
}