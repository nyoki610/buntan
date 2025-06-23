import Foundation
import RealmSwift

class RealmCheckRecord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var gradeRawValue: Double
    @Persisted var date: Date
    @Persisted var correctCount: Int
    @Persisted var estimatedCount: Int
    
    var grade: EikenGrade? {
        EikenGrade(rawValue: gradeRawValue)
    }
}

extension RealmCheckRecord: ConveretableRealmObject {
    
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
