//import Foundation
//import SwiftUI
//
//
//extension SheetRealmAPI {
//    
//    static func getBook(
//        eikenGrade: EikenGrade,
//        bookCategory: BookCategory,
//        bookConfig: BookConfiguration
//    ) -> Book? {
//        
//        guard let bookList = getBookListByGradeAndCategory(
//            eikenGrade: eikenGrade,
//            bookCategory: bookCategory
//        ) else { return nil }
//        
//        guard let targetBook = bookList.first(where: { book in
//            book.config == bookConfig
//        }) else { return nil }
//        
//        return targetBook
//    }
//}
