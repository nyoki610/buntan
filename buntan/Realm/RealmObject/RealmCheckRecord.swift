import Foundation
import RealmSwift

class RealmCheckRecord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var gradeRawValue: Double
    @Persisted var date: Date
    @Persisted var correctCount: Int
    @Persisted var estimatedCount: Int
    
    var grade: Eiken? {
        Eiken(rawValue: gradeRawValue)
    }
}

extension RealmCheckRecord {
    
    func convertToNonRealm() -> CheckRecord? {
        
        guard let grade = grade else { return nil }
        
        let checkRecord = CheckRecord(id.stringValue,
                                      grade,
                                      date,
                                      correctCount,
                                      estimatedCount)
        return checkRecord
    }
}
