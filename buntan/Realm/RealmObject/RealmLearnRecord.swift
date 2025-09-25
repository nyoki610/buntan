import Foundation
import RealmSwift

class RealmLearnRecord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var learnedCardCount: Int
}

extension RealmLearnRecord: NonRealmConvertible {
    func toNonRealm() -> LearnRecord {
        return LearnRecord(
            id: id.stringValue,
            date: date,
            learnedCardCount: learnedCardCount
        )
    }
}
