namespace backend.Application.DTO.Product.CategoryDTO.DTO
{
    public class CategoryDomainDTO
    {
        public List<string> Men { get; set; } = new List<string>();
        public List<string> Women { get; set; } = new List<string>();
        public List<string> Kids { get; set; } = new List<string>();
        public List<string> Accessories { get; set; } = new List<string>();
        public List<string> Shoes { get; set; } = new List<string>();
    }
}
