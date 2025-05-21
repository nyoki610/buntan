import Foundation

enum BookDesign: CaseIterable {
    
    case freqA
    case freqB
    case freqC
    case noun
    case verb
    case adjective
    case adverb
    case idiom
    
    var title: String {
        
        switch self {
        case .freqA: return "頻出度A"
        case .freqB: return "頻出度B"
        case .freqC: return "頻出度C"
        case .noun: return "名詞"
        case .verb: return "動詞"
        case .adjective: return "形容詞"
        case .adverb: return "副詞"
        case .idiom: return "熟語"
        }
    }

    var bookType: BookType {
        switch self {
        case .freqA, .freqB, .freqC: return .freq
        case .noun, .verb, .adjective, .adverb, .idiom: return .pos
        }
    }
    
    var description: String? {
        switch self {
        case .freqA: return "正解として出題された単語を収録"
        case .freqB: return "複数回出題された単語を収録"
        case .freqC: return "１度だけ出題された単語を収録"
        default: return nil
        }
    }
    
    func book(_ cards: [Card]) -> Book {
        switch self {
        case .freqA, .freqB, .freqC:
            var sections: [Section] = []
            for pos in Pos.allCases {
                sections += getSections(cards, pos, true)
            }
            return Book(self, sections)
        case .noun, .verb, .adjective, .adverb, .idiom:
            guard let pos = self.convertToPos else { return EmptyModel.book }
            return Book(self, getSections(cards, pos, false))
        }
    }
    
    private func getSections(_ cards: [Card], _ pos: Pos, _ isFreq: Bool) -> [Section] {
        
        let filteredCards = filteredCards(cards, pos)
        
        var sections: [Section] = []
        let sectionCount = (filteredCards.count + 99) / 100

        for i in 0..<sectionCount {
            let start = i * 100
            let end = min((i + 1) * 100, filteredCards.count)
            sections.append(Section(isFreq ? "\(pos.jaTitle) \(i + 1)" : "Section \(i + 1)",
                                    Array(filteredCards[start..<end])))
        }
        return sections
    }
    
    private func filteredCards(_ cards: [Card], _ pos: Pos) -> [Card] {
        let cards = cards.filter { $0.meaning != "" && $0.pos == pos}
        switch self {
        case .freqA: return cards.filter { $0.priority >= 10 }
        case .freqB: return cards.filter { $0.priority < 10 && $0.priority > 1 }
        case .freqC: return cards.filter { $0.priority == 1 }
        case .noun, .verb, .adjective, .adverb, .idiom: return cards
        }
    }
    
    private var convertToPos: Pos? {
        switch self {
        case .freqA, .freqB, .freqC: return nil
        case .noun: return .noun
        case .verb: return .verb
        case .adjective: return .adjective
        case .adverb: return .adverb
        case .idiom: return .idiom
        }
    }
}
