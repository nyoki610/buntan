import Foundation

struct LearnRecord: Identifiable, Hashable {
    
    let id: String
    let date: Date
    var learnedCardCount: Int
    
    init(_ id: String, _ date: Date, _ learnedCardCount: Int) {
        self.id = id
        self.date = date
        self.learnedCardCount = learnedCardCount
    }
}

extension LearnRecord {
    
    func convertToRealm() -> RealmLearnRecord {
        
        let realmLearnRecord = RealmLearnRecord()
        
        realmLearnRecord.date = date
        realmLearnRecord.learnedCardCount = learnedCardCount
        
        return realmLearnRecord
    }
}
