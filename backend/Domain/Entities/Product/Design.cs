using backend.Domain.Common;

namespace backend.Domain.Entities.Product;

public class Design  : BaseEntity
{
    public required string Name { get; set; }
    public int ParentFilterType { get; set; } = 1;
    
    public override string ToString()
    {
        return $"Id: {Id}, Name: {Name}, ParentFilterType: {ParentFilterType}";
    }
}