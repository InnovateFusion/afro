using System.ComponentModel.DataAnnotations;
using backend.Domain.Common;

namespace backend.Domain.Entities.Common
{
    public class Image : BaseEntity
    {
        [Required]
        public required string ImageUrl { get; set; }

        [Required]
        public required User.User User { get; set; }

        public required bool IsDeleted { get; set; } = false;
        
        public DateTime DeletedAt { get; set; }
        
        public override string ToString()
        {
            return $"Id: {Id}, ImageUrl: {ImageUrl}, User: {User}";
        }
    }
}
