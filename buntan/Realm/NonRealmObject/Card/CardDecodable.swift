import Foundation


extension Card: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case index, word, pos
        case phrase, meaning, sentence, translation
        case startPosition = "start_position"
        case endPosition = "end_position"
        case infoList = "infomation_list"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        self.index = try container.decode(Int.self, forKey: .index)
        self.word = try container.decode(String.self, forKey: .word)
        
        do {
            let posValue = try container.decode(Int.self, forKey: .pos)
            guard let pos = Pos(rawValue: posValue) else {
                throw DecodingError.dataCorruptedError(forKey: .pos, in: container, debugDescription: "Invalid POS value")
            }
            self.pos = pos
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .pos, in: container, debugDescription: "Failed to decode POS value: \(error.localizedDescription)")
        }
        
        self.phrase = try container.decodeIfPresent(String.self, forKey: .phrase) ?? ""
        self.meaning = try container.decodeIfPresent(String.self, forKey: .meaning) ?? ""
        self.sentence = try container.decodeIfPresent(String.self, forKey: .sentence) ?? ""
        self.translation = try container.decodeIfPresent(String.self, forKey: .translation) ?? ""
        self.startPosition = try container.decodeIfPresent(Int.self, forKey: .startPosition) ?? 0
        self.endPosition = try container.decodeIfPresent(Int.self, forKey: .endPosition) ?? 0
        
        self.infoList = try container.decode([Info].self, forKey: .infoList)
        
        self.statusFreq = .notLearned
        self.statusPos = .notLearned
    }
}
