import SwiftUI
import RealmSwift

enum Eiken: Double, CaseIterable {
    
    case first = 1.0
    case preFirst = 1.5
    case second = 2.0
    case preSecond = 2.5
    case third = 3.0
    case fourth = 4.0
    case fifth = 5.0
    
    var index: Int {
        switch self {
        case .first: return 0
        case .preFirst: return 1
        case .second: return 2
        case .preSecond: return 3
        case .third: return 4
        case .fourth: return 5
        case .fifth: return 6
        }
    }
    
    var title: String {
        switch self {
        case .first: return "1級"
        case .preFirst: return "準1級"
        case .second: return "2級"
        case .preSecond: return "準2級"
        case .third: return "3級"
        case .fourth: return "4級"
        case .fifth: return "5級"
        }
    }
    
    var color: Color {
        switch self {
        case .first: return .green
        case .preFirst: return Color(red: 178 / 255, green: 210 / 255, blue: 53 / 255)
        case .second: return .blue
        case .preSecond: return .cyan
        case .third: return .orange
        case .fourth: return .red
        case .fifth: return .pink
        }
    }
    
    var questionCount: Int {
        switch self {
        case .first: return 22
        case .preFirst: return 22
        case .second: return 22
        case .preSecond: return 22
        case .third: return 22
        case .fourth: return 22
        case .fifth: return 22
        }
    }
    
    var checkConfig: (Int, Int, Int) {
        
        func randomValue(_ value: Int) -> Int {
            let range = (max(0, value - 1))...(value + 1)
            return Int.random(in: range)
        }
        
        func getIntTupel(_ value1: Int, _ value2: Int) -> (Int, Int, Int) {
            let randamValue1 = randomValue(value1)
            let randamValue2 = randomValue(value2)
            let value3 = questionCount - randamValue1 - randamValue2
            return (randamValue1, randamValue2, value3)
        }
        
        switch self {
        case .first: return getIntTupel(9, 7)
        case .preFirst: return getIntTupel(0, 0)
        case .second: return getIntTupel(0, 0)
        case .preSecond: return getIntTupel(0, 0)
        case .third: return getIntTupel(0, 0)
        case .fourth: return getIntTupel(0, 0)
        case .fifth: return getIntTupel(0, 0)
        }
    }
    
    func extractForCheck(_ booksList: [[Book]]) -> [Card]? {

        func extractFromBook(_ book: Book, _ count: Int) -> [Card] {
            book.sections.flatMap { $0.cards }.randomElements(count)
        }
        
        guard booksList.indices.contains(index) else { return nil }
        
        let books = booksList[index]
        
        guard
            let bookFreqA = books.filter({ $0.id == .freqA }).first,
            let bookFreqB = books.filter({ $0.id == .freqB }).first,
            let bookFreqC = books.filter({ $0.id == .freqC }).first else { return nil }
        
        let (countFreqA, countFreqB, countFreqC) = checkConfig
        
        return (extractFromBook(bookFreqA, countFreqA) + extractFromBook(bookFreqB, countFreqB) + extractFromBook(bookFreqC, countFreqC)).shuffled()
    }
    
    func setupOptions(booksList: [[Book]], cards: [Card], isBookView: Bool) -> [[Option]]? {
        
        func convertBookToOptions(_ book: Book) -> [Option] {
            book.sections.flatMap { $0.cards.compactMap {$0.convertToOption()} }
        }
        
        guard booksList.indices.contains(index) else { return nil }
        
        let books = booksList[index]
        
        guard
            let bookNoun = books.filter({ $0.id == .noun }).first,
            let bookVerb = books.filter({ $0.id == .verb }).first,
            let bookAdjective = books.filter({ $0.id == .adjective }).first,
            let bookAdverb = books.filter({ $0.id == .adverb }).first,
            let bookIdiom = books.filter({ $0.id == .idiom }).first else { return nil }
        
        let optionsRef = [
            convertBookToOptions(bookNoun),
            convertBookToOptions(bookVerb),
            convertBookToOptions(bookAdjective),
            convertBookToOptions(bookAdverb),
            convertBookToOptions(bookIdiom)
        ]
        
        let options = cards.map { card in
            let filteredRef = optionsRef[card.pos.rawValue - 1].filter { $0.word != card.word }
            let randomOptions = filteredRef.shuffled().prefix(isBookView ? 3 : 4)
            return Array(Set([card.convertToOption()] + randomOptions)).shuffled()
        }
        
        return options
    }
}
