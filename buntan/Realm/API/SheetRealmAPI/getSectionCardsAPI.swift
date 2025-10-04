import Foundation


extension SheetRealmAPI {
    
    static func getSectionCards(
        eikenGrade: EikenGrade,
        bookCategory: BookCategory,
        bookConfig: BookConfiguration,
        sectionTitle: String
    ) -> [Card]? {
        
        let bookService = BookService()
        guard let cards = try? bookService.getBooks(for: eikenGrade, category: bookCategory)
            .first(where: { $0.config == bookConfig })?
            .sections.first(where: { $0.title == sectionTitle })?
            .cards else { return nil }
        
        return cards
    }
}
