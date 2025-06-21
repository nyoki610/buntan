import Foundation

protocol BookBaseProtocol {
    var id: BookDesign { get }
}


struct Book: Hashable, BookBaseProtocol {
    let id: BookDesign
    var sections: [Section]
    
    init(_ id: BookDesign, _ sections: [Section]) {
        self.id = id
        self.sections = sections
    }
    
    var bookCategory: BookCategory { id.bookCategory }
    var title: String { id.title }
    var description: String? { id.description }
    
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
