using backend.Domain.Common;

namespace backend.Domain.Entities.Product
{
    public class Color : BaseEntity
    {
        public required string Name { get; set; }
        public required string HexCode { get; set; }
        public int ParentFilterType { get; set; } = 1;
        
        public override string ToString()
        {
            return $"Id: {Id}, Name: {Name}, HexCode: {HexCode}, ParentFilterType: {ParentFilterType}";
        }
    }
}
