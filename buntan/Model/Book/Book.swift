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
