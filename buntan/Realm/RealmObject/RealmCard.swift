import Foundation
import RealmSwift

class RealmCard: Object, IdentifiableRealmObject {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var index: Int
    @Persisted var word: String
    @Persisted var posRawValue: Int
    @Persisted var phrase: String
    @Persisted var meaning: String
    @Persisted var sentence: String
    @Persisted var translation: String
    @Persisted var startPosition: Int
    @Persisted var endPosition: Int
    @Persisted var infoList: List<RealmInfo>
    @Persisted var statusFreqRawValue: Int
    @Persisted var statusPosRawValue: Int
}

extension RealmCard: ConveretableRealmObject {
    
    func convertToNonRealm() -> Card? {
        
        guard
            let pos = Pos(rawValue: posRawValue),
            let statusFreq = CardStatus(rawValue: statusFreqRawValue),
            let statusPos = CardStatus(rawValue: statusPosRawValue) else {
            return nil
        }
        
        return Card(id: self.id.stringValue,
                    index: self.index,
                    word: self.word,
                    pos: pos,
                    phrase: self.phrase,
                    meaning: self.meaning,
                    sentence: self.sentence,
                    translation: self.translation,
                    startPosition: self.startPosition,
                    endPosition: self.endPosition,
                    infoList: self.infoList.map { $0.convertToNonRealm() },
                    statusFreq: statusFreq,
                    statusPos: statusPos
        )
    }
}
