
using backend.Application.Enum;

namespace backend.Application.DTO.Product.DesignDTO.DTO;

public class BaseDesignDTO
{ 
    public required string Name { get; set; }
    public ParentFilterType ParentFilterType { get; set; } 
}