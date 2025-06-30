import Foundation
import SwiftUI


extension SheetRealmAPI {
    
    static func getBookListByGradeAndCategory(
        eikenGrade: EikenGrade,
        bookCategory: BookCategory
    ) -> [Book]? {
        
        guard let cards = SheetRealmCruds
            .getSheetByGrade(eikenGrade: eikenGrade)?
            .cardList else { return nil }
        
        let bookList = BookConfiguration
            .allCases
            .filter { $0.bookCategory == bookCategory }
            .map { book(cards: cards, bookConfig: $0) }
        
        return bookList
    }
    
    private static func book(cards: [Card], bookConfig: BookConfiguration) -> Book {
        
        let book: Book
        
        switch bookConfig {
        case .frequency(let freqConfig):
            let filteredCards = freqConfig.filterCardsByFreq(cards: cards)
            var sections: [Section] = []
            for pos in Pos.allCases {
                sections += getSections(cards: filteredCards, pos: pos, isFreq: true)
            }
            
            book = Book(
                config: bookConfig,
                sections: sections
            )

        case .pos(let posConfig):
            
            book = Book(
                config: bookConfig,
                sections: getSections(cards: cards, pos: posConfig.posValue, isFreq: false)
            )
        }
        
        return book
    }
    
    private static func getSections(cards: [Card], pos: Pos, isFreq: Bool) -> [Section] {
        
        let filteredCards = filterCardsByPos(cards: cards, pos: pos)
        
        var sections: [Section] = []
        let sectionCount = (filteredCards.count + 99) / 100

        for i in 0..<sectionCount {
            let start = i * 100
            let end = min((i + 1) * 100, filteredCards.count)
            sections.append(Section(title: isFreq ? "\(pos.jaTitle) \(i + 1)" : "Section \(i + 1)",
                                    cards: Array(filteredCards[start..<end])))
        }
        return sections
    }
    
    private static func filterCardsByPos(cards: [Card], pos: Pos) -> [Card] {
        let filteredCards = cards.filter { $0.meaning != "" && $0.pos == pos}
        return filteredCards
    }
}
