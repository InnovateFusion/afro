
using backend.Domain.Common;

namespace backend.Domain.Entities.Product
{
    public class Size : BaseEntity
    {
        public required string Name { get; set; }
        public required string Abbreviation { get; set; }
        public int ParentFilterType { get; set; } = 1;
        
        public override string ToString()
        {
            return $"Id: {Id}, Name: {Name}, Abbreviation: {Abbreviation}, ParentFilterType: {ParentFilterType}";
        }
    }
}
