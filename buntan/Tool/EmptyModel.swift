import Foundation

enum EmptyModel {
    
    static let sheet = Sheet(
        id: "",
        grade: .first,
        cardList: [])
    
    static let card = Card(
        id: "",
        index: 0,
        word: "",
        pos: .noun,
        phrase: "",
        meaning: "",
        sentence: "",
        translation: "",
        startPosition: 0,
        endPosition: 0,
        infoList: [],
        statusFreq: .notLearned,
        statusPos: .notLearned
    )
    
    static let book = Book(.freqA, [])
    static let section = Section("", [])
    
    static let checkRecord = CheckRecord("", .first, Date(), 0, 0)
    
}
