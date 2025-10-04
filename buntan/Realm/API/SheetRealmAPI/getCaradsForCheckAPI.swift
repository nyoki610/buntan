//import Foundation
//
//
//extension SheetRealmAPI {
//    
//    static func getCaradsForCheck(eikenGrade: EikenGrade) -> [Card]? {
//        
//        func extractCardFromBook(_ book: Book, _ count: Int) -> [Card] {
//            book.sections.flatMap { $0.cards }.randomElements(count)
//        }
//        
//        let bookService = BookService()
//        guard let bookList = try? bookService.getBooks(
//            for: eikenGrade,
//            category: .freq
//        ) else { return nil }
//        
//        guard
//            let bookFreqA = bookList.first(where: {$0.config == .frequency(.freqA)}),
//            let bookFreqB = bookList.first(where: {$0.config == .frequency(.freqB)}),
//            let bookFreqC = bookList.first(where: {$0.config == .frequency(.freqC)}) else { return nil }
//        
//        let config = eikenGrade.checkConfig
//        
//        let freqACards: [Card] = extractCardFromBook(bookFreqA, config.highFrequencyCount)
//        let freqBCards: [Card] = extractCardFromBook(bookFreqB, config.mediumFrequencyCount)
//        let freqCCards: [Card] = extractCardFromBook(bookFreqC, config.lowFrequencyCount)
//        
//        return (freqACards + freqBCards + freqCCards).shuffled()
//    }
//}
