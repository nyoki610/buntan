import Foundation


enum BookConfiguration: Hashable {
    case frequency(FrequencyBookConfiguration)
    case pos(PosBookConfiguration)

    var bookCategory: BookCategory {
        switch self {
        case .frequency(_): return .freq
        case .pos(_): return .pos
        }
    }
}

extension BookConfiguration: CaseIterable {
    static var allCases: [BookConfiguration] {
        return FrequencyBookConfiguration.allCases.map { .frequency($0) } +
               PosBookConfiguration.allCases.map { .pos($0) }
    }
}


extension BookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        switch self {
        case .frequency(let config): return config.title
        case .pos(let config): return config.title
        }
    }
}


extension BookConfiguration {
    
    func book(_ cards: [Card]) -> Book {
        switch self {
        case .frequency(let freqConfig):
            let filteredCards = freqConfig.filterCardsByFreq(cards: cards)
            var sections: [Section] = []
            for pos in Pos.allCases {
                sections += getSections(filteredCards, pos, true)
            }
            return Book(config: self, sections: sections)
        case .pos(let posConfig):
            
            return Book(config: self, sections: getSections(cards, posConfig.posValue, false))
        }
    }
    
    private func getSections(_ cards: [Card], _ pos: Pos, _ isFreq: Bool) -> [Section] {
        
        let filteredCards = filterCardsByPos(cards: cards, pos: pos)
        
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
    
    private func filterCardsByPos(cards: [Card], pos: Pos) -> [Card] {
        let filteredCards = cards.filter { $0.meaning != "" && $0.pos == pos}
        return filteredCards
    }
}
