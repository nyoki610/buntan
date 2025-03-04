import Foundation
import RealmSwift

class RealmLearnRecord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var learnedCardCount: Int
}

extension RealmLearnRecord {
    
    func convertToNonRealm() -> LearnRecord {
        return LearnRecord(id.stringValue,
                           date,
                           learnedCardCount)
    }
}
