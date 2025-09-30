import Foundation


struct Book: Hashable {
    
    let id = UUID().uuidString
    let config: BookConfiguration
    var sections: [Section]
    
    init(config: BookConfiguration, sections: [Section]) {
        self.config = config
        self.sections = sections
    }
    
    var bookCategory: BookCategory { config.bookCategory }
    var title: String { config.title }
    
    var cardsCount: Int {
        sections.map(\.cards.count).reduce(0, +)
    }
}

struct Section: Hashable {
    let id: String = UUID().uuidString
    let title: String
    var cards: [Card]
    
    init(title: String, cards: [Card]) {
        self.title = title
        self.cards = cards
    }

    func progressPercentage(_ bookCategory: BookCategory) -> Int {
        
        let completedCount = cards.filter { $0.status(bookCategory) == .completed }.count
        return cards.isEmpty ? 0 : Int(Double(completedCount) / Double(cards.count) * 100.0)
    }
}

enum BookFactory {
    
    static func create(from cards: [Card], with config: BookConfiguration) -> Book {
        switch config {
        case .frequency(let freqConfig):
            let filteredCards = freqConfig.filterCardsByFreq(cards: cards)
            var sections: [Section] = []
            for pos in Pos.allCases {
                sections += getSections(cards: filteredCards, pos: pos, isFreq: true)
            }
            return Book(config: config,sections: sections)

        case .pos(let posConfig):
            return Book(config: config, sections: getSections(cards: cards, pos: posConfig.posValue, isFreq: false))
        }
    }
    
    private static func getSections(cards: [Card], pos: Pos, isFreq: Bool) -> [Section] {
        let filteredCards = filter(cards: cards, by: pos)
        var sections: [Section] = []
        let sectionCount = (filteredCards.count + 99) / 100
        for i in 0..<sectionCount {
            let start = i * 100
            let end = min((i + 1) * 100, filteredCards.count)
            sections.append(
                Section(
                    title: isFreq ? "\(pos.jaTitle) \(i + 1)" : "Section \(i + 1)",
                    cards: Array(filteredCards[start..<end])
                )
            )
        }
        return sections
    }
    
    private static func filter(cards: [Card], by pos: Pos) -> [Card] {
        return cards.filter { $0.meaning != "" && $0.pos == pos}
    }
}
