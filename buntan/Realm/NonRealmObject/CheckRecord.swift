import Foundation

struct CheckRecord: Identifiable {
    
    let id: String
    let grade: Eiken
    let date: Date
    let correctCount: Int
    let estimatedCount: Int
    
    init(_ id: String, _ grade: Eiken, _ date: Date, _ correctCount: Int,_ estimatedCount: Int) {
        self.id = id
        self.grade = grade
        self.date = date
        self.correctCount = correctCount
        self.estimatedCount = estimatedCount
    }
}

extension CheckRecord {
    
    func convertToRealm() -> RealmCheckRecord {
        
        let realmCheckRecord = RealmCheckRecord()

        realmCheckRecord.gradeRawValue = grade.rawValue
        realmCheckRecord.date = date
        realmCheckRecord.correctCount = correctCount
        realmCheckRecord.estimatedCount = estimatedCount
        
        return realmCheckRecord
    }
}
