import Foundation


extension SheetRealmAPI {
    
    static func getSectionCards(
        eikenGrade: EikenGrade,
        bookCategory: BookCategory,
        bookConfig: BookConfiguration,
        sectionTitle: String
    ) -> [Card]? {
        
        let bookUseCase = BookUseCase()
        guard let cards = try? bookUseCase.getBooks(for: eikenGrade, category: bookCategory)
            .first(where: { $0.config == bookConfig })?
            .sections.first(where: { $0.title == sectionTitle })?
            .cards else { return nil }
        
        return cards
    }
}
