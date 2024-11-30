using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Domain.Entities.Product;

public class ProductView
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    [ForeignKey("Product")]
    public required string ProductId { get; set; }
    public Product Product { get; set; }
    [ForeignKey("User")]
    public string? UserId { get; set; }
    public required DateTime ViewedAt { get; set; } = DateTime.Now;
    
    public override string ToString()
    {
        return $"Id: {Id}, ProductId: {ProductId}, UserId: {UserId}, ViewedAt: {ViewedAt}";
    }
}