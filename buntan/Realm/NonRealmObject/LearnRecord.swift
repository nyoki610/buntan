import Foundation
import RealmSwift

struct LearnRecord: Identifiable, Hashable {
    
    let id: String
    let date: Date
    var learnedCardCount: Int
    
    init(
        id: String,
        date: Date,
        learnedCardCount: Int
    ) {
        self.id = id
        self.date = date
        self.learnedCardCount = learnedCardCount
    }
}

extension LearnRecord: RealmConvertible {
    
    func toRealm(with idType: RealmIdType) throws -> RealmLearnRecord {
        let realmLearnRecord = RealmLearnRecord()
        try setId(to: realmLearnRecord, idType: idType)
        realmLearnRecord.date = date
        realmLearnRecord.learnedCardCount = learnedCardCount
        return realmLearnRecord
    }
}
