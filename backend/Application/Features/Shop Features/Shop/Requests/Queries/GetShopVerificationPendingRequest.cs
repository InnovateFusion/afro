using backend.Application.Response;
using MediatR;

namespace backend.Application.Features.Shop_Features.Shop.Requests.Queries;

public class GetShopVerificationPendingRequest(int skip = 0, int limit = 10): IRequest<List<Domain.Entities.Shop.Shop>>
{
    public int Skip { get; set; } = skip;
    public int Limit { get; set; } = limit;
}