import Foundation
import RealmSwift

struct Card: Hashable {
    let id: String
    let index: Int /// saveProgress, resetProgress 内で id として使用される
    let word: String
    let pos: Pos
    let phrase: String
    let meaning: String
    let sentence: String
    let translation: String
    let startPosition: Int
    let endPosition: Int
    let infoList: [Info]
    var statusFreq: CardStatus
    var statusPos: CardStatus
    
    enum CardStatus: Int {
        case notLearned
        case learning
        case completed
    }

    init(id: String,
         index: Int,
         word: String,
         pos: Pos,
         phrase: String,
         meaning: String,
         sentence: String,
         translation: String,
         startPosition: Int,
         endPosition: Int,
         infoList: [Info] = [],
         statusFreq: CardStatus,
         statusPos: CardStatus
        ) {
        self.id = id
        self.index = index
        self.word = word
        self.pos = pos
        self.phrase = phrase
        self.meaning = meaning
        self.sentence = sentence
        self.translation = translation
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.infoList = infoList
        self.statusFreq = statusFreq
        self.statusPos = statusPos
    }
    
    func status(_ bookCategory: BookCategory) -> CardStatus {
        bookCategory == .freq ? statusFreq : statusPos
    }
    
    mutating func toggleStatus(_ bookCategory: BookCategory, _ cardStatus: CardStatus) {
        switch bookCategory {
        case .freq: statusFreq = cardStatus
        case .pos: statusPos = cardStatus
        }
    }
    
    func convertToOption() -> Option {
        
        return Option(id: id, word: word, meaning: meaning)
    }
    
    ///   要確認
    static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.id == rhs.id
    }
    ///   要確認
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    ///   要確認
}

