import Foundation


extension SheetRealmAPI {
    
    static func getSectionCards(
        eikenGrade: EikenGrade,
        bookCategory: BookCategory,
        bookConfig: BookConfiguration,
        sectionTitle: String
    ) -> [Card]? {
        
        guard let cards = getBookListByGradeAndCategory(
            eikenGrade: eikenGrade,
            bookCategory: bookCategory
        )?
            .first(where: { $0.config == bookConfig })?
            .sections.first(where: { $0.title == sectionTitle })?
            .cards else { return nil }
        
        return cards
    }
}
