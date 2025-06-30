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
    
    static let book = Book(config: BookConfiguration.frequency(.freqA), sections: [])
    static let section = Section(title: "", cards: [])
    
    static let checkRecord = CheckRecord(id: "", grade: .first, date: Date(), correctCount: 0, estimatedCount: 0)
}
