import Foundation
import SwiftUI


extension SheetRealmAPI {
    
    static func getBookListByGradeAndCategory(
        eikenGrade: EikenGrade,
        bookCategory: BookCategory
    ) -> [Book]? {
        
        let sheetRepository = SheetRepository()
        guard let cards = try? sheetRepository
            .getSheet(of: eikenGrade)
            .cardList else { return nil }
        
        let bookList = BookConfiguration
            .allCases
            .filter { $0.bookCategory == bookCategory }
            .map { BookFactory.create(from: cards, with: $0) }
        
        return bookList
    }
}
