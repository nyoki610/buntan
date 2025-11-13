import Foundation
import RealmSwift

class RealmInfo: Object, IdentifiableRealmObject {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var year: Int
    @Persisted var time: Int
    @Persisted var isAnswer: Bool
}

extension RealmInfo: ConveretableRealmObject {
    
    func convertToNonRealm() -> Info {
        return Info(id: self.id.stringValue, year: self.year, time: self.time, isAnswer: self.isAnswer)
    }
}

extension RealmInfo: NonRealmConvertible {
    
    func toNonRealm() -> Info {
        return Info(
            id: id.stringValue,
            year: year,
            time: time,
            isAnswer: isAnswer
        )
    }
}
