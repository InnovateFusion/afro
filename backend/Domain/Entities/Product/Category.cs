using backend.Domain.Common;

namespace backend.Domain.Entities.Product
{
	public class Category : BaseEntity
	{
		public required string Name { get; set; }
		public required string Image { get; set; }
		public required string Domain { get; set; }
		public int ParentFilterType { get; set; } = 1;
		
		public override string ToString()
		{
			return $"Id: {Id}, Name: {Name}, Image: {Image}, Domain: {Domain}, ParentFilterType: {ParentFilterType}";
		}
	}
}
