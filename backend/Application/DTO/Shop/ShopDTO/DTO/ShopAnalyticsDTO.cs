namespace backend.Application.DTO.Shop.ShopDTO.DTO;

public class ShopAnalyticsDTO
{
   public  int TotalFollowers { get; set; }
   public int TotalReviews { get; set; }
   public int TotalFavorites { get; set; }
  public  int TotalProducts { get; set; }
  public  int TotalContacts { get; set; }
   public int TotalViews { get; set; }
   
   public int OneStarReviews { get; set; }
    public int TwoStarReviews { get; set; }
    public int ThreeStarReviews { get; set; }
    public int FourStarReviews { get; set; }
    public int FiveStarReviews { get; set; }
}