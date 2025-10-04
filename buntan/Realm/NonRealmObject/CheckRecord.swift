import Foundation

struct CheckRecord: Identifiable {
    
    let id: String
    let grade: EikenGrade
    let date: Date
    let correctCount: Int
    let estimatedCount: Int
    
    init(
        id: String,
        grade: EikenGrade,
        date: Date,
        correctCount: Int,
        estimatedCount: Int
    ) {
        self.id = id
        self.grade = grade
        self.date = date
        self.correctCount = correctCount
        self.estimatedCount = estimatedCount
    }
}

extension CheckRecord: RealmConvertible {
    
    func toRealm(with idType: RealmIdType) throws -> RealmCheckRecord {
        let realmCheckRecord = RealmCheckRecord()
        try setId(to: realmCheckRecord, idType: idType)
        realmCheckRecord.gradeRawValue = grade.rawValue
        realmCheckRecord.date = date
        realmCheckRecord.correctCount = correctCount
        realmCheckRecord.estimatedCount = estimatedCount
        return realmCheckRecord
    }
}
