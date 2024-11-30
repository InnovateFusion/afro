using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Domain.Entities.Product
{
    public class ProductColor
    {
        public string Id { get; set; } = Guid.NewGuid().ToString();

        [ForeignKey("Product")]
        public required string ProductId { get; set; }

        [Required]
        public required virtual Color Color { get; set; }
        
        public override string ToString()
        {
            return $"Id: {Id}, ProductId: {ProductId}, Color: {Color}";
        }
    }
}
