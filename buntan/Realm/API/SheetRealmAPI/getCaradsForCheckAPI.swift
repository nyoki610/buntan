import Foundation


extension SheetRealmAPI {
    
    static func getCaradsForCheck(eikenGrade: EikenGrade) -> [Card]? {
        
        func extractCardFromBook(_ book: Book, _ count: Int) -> [Card] {
            book.sections.flatMap { $0.cards }.randomElements(count)
        }
        
        let bookUseCase = BookUseCase()
        guard let bookList = try? bookUseCase.getBooks(
            for: eikenGrade,
            category: .freq
        ) else { return nil }
        
        guard
            let bookFreqA = bookList.first(where: {$0.config == .frequency(.freqA)}),
            let bookFreqB = bookList.first(where: {$0.config == .frequency(.freqB)}),
            let bookFreqC = bookList.first(where: {$0.config == .frequency(.freqC)}) else { return nil }
        
        let (freqACount, freqBCount, freqCCount) = eikenGrade.checkConfig
        
        let freqACards: [Card] = extractCardFromBook(bookFreqA, freqACount)
        let freqBCards: [Card] = extractCardFromBook(bookFreqB, freqBCount)
        let freqCCards: [Card] = extractCardFromBook(bookFreqC, freqCCount)
        
        return (freqACards + freqBCards + freqCCards).shuffled()
    }
}
