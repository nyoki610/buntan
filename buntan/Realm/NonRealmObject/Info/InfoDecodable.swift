import Foundation


extension Info: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case year
        case time
        case isAnswer = "is_answer"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        /// id is automatically initialized
        self.id = UUID().uuidString
        self.year = try container.decode(Int.self, forKey: .year)
        self.time = try container.decode(Int.self, forKey: .time)
        self.isAnswer = try container.decode(Bool.self, forKey: .isAnswer)
    }
}
