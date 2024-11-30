using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using backend.Domain.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace backend.Domain.Entities.Product
{
    public class Product : BaseEntity
    {
        [Required]
        public required string Title { get; set; }

        [Required]
        public required string Description { get; set; }
        [Required]
        public required float Price { get; set; }
        [ForeignKey("Shop")]
        public required string ShopId { get; set; }
        public required Shop.Shop Shop { get; set; }
        [Required]
        public required bool InStock { get; set; }
        [Required]
        public required bool IsDeliverable { get; set; } = false;
        [Required] 
        public required int AvailableQuantity { get; set; } = 0;
        public string? VideoUrl { get; set; }
        [Required]
        public required bool IsNew { get; set; } = true;
        [Required]
        public required string Status { get; set; }
        public virtual HashSet<ProductDesign> ProductDesigns { get; set; } = new HashSet<ProductDesign>();
        
        public virtual HashSet<ProductBrand> ProductBrands { get; set; } = new HashSet<ProductBrand>();
        public virtual HashSet<ProductImage> ProductImages { get; set; } = new HashSet<ProductImage>();
        public virtual HashSet<ProductSize> ProductSizes { get; set; } = new HashSet<ProductSize>();
        public virtual HashSet<ProductColor> ProductColors { get; set; } =
            new HashSet<ProductColor>();
        public virtual HashSet<ProductMaterial> ProductMaterials { get; set; } =
            new HashSet<ProductMaterial>();
        public virtual HashSet<ProductCategory> ProductCategories { get; set; } =
            new HashSet<ProductCategory>();
        public required bool IsNegotiable { get; set; } = false;
        
        public required bool IsDeleted { get; set; } = false;
        public required int ProductApprovalStatus { get; set; } = 0;
        public DateTime ProductApprovalDate { get; set; }
        
        public DateTime DeletedAt { get; set; }
        
        public override string ToString()
        {
            return $"Id: {Id}, Title: {Title}, Description: {Description}, Price: {Price}, ShopId: {ShopId}, InStock: {InStock}, VideoUrl: {VideoUrl}, Status: {Status}, IsNegotiable: {IsNegotiable}";
        }
    }
}
