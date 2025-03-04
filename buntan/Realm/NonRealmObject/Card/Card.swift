import Foundation
import RealmSwift

class Card: Hashable {
    let id: String
    let index: Int
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
    
    func status(_ bookType: BookType) -> CardStatus {
        bookType == .freq ? statusFreq : statusPos
    }
    
    func toggleStatus(_ bookType: BookType, _ cardStatus: CardStatus) {
        switch bookType {
        case .freq: statusFreq = cardStatus
        case .pos: statusPos = cardStatus
        }
    }
    
    func convertToRealm() -> RealmCard {
        let realmCard = RealmCard()
        
        realmCard.index = index
        realmCard.word = word
        realmCard.posRawValue = pos.rawValue
        realmCard.phrase = phrase
        realmCard.meaning = meaning
        realmCard.sentence = sentence
        realmCard.translation = translation
        realmCard.startPosition = startPosition
        realmCard.endPosition = endPosition
        realmCard.statusFreqRawValue = statusFreq.rawValue
        realmCard.statusPosRawValue = statusPos.rawValue
        
        let realmInfoList = List<RealmInfo>()
        for info in infoList {
            let realmInfo = info.convertToRealm()
            realmInfoList.append(realmInfo)
        }
        realmCard.infoList = realmInfoList
        
        return realmCard
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
