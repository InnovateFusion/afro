using Newtonsoft.Json;

namespace backend.Application.DTO.Common.Chat.DTO;

public class RealTimeChatUserDataDto
{ 
    public required string id { get; set; }
    public required string name { get; set; }
    public required string avatar { get; set; }
    
}
