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
//    var description: String? { id.description }
    
    var cardsCount: Int {
        sections.map(\.cards.count).reduce(0, +)
    }

    /// for developer
    var customCount: Int {
        sections.reduce(0) { $0 + $1.cards.reduce(0) { $0 + $1.infoList.count } }
    }
    ///
}

struct Section: Hashable {
    let id: String
    var cards: [Card] = []
    
    init(_ id: String, _ cards: [Card]) {
        self.id = id
        self.cards = cards
    }

    func progressPercentage(_ bookCategory: BookCategory) -> Int {
        
        let completedCount = cards.filter { $0.status(bookCategory) == .completed }.count
        return cards.isEmpty ? 0 : Int(Double(completedCount) / Double(cards.count) * 100.0)
    }
}
