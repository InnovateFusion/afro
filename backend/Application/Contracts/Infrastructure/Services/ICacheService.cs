namespace backend.Application.Contracts.Infrastructure.Services;

public interface ICacheService
{

    Task Add<T>(string key, T value);
    Task<T> Get<T>(string key);
    Task Remove(string key);
    Task AddToSet(string key, string value);
    Task RemoveFromSet(string key, string value);
    Task<IEnumerable<string>> GetSetMembers(string key);
    Task<bool> KeyExists(string key);
    Task AddList<T>(string key, List<T> values);
    Task<List<T>> GetList<T>(string key);
    Task RemoveList(string key);
}