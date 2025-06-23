import Foundation


class LearnRecordRealmCruds: RealmCruds {
    
    static func getLearnRecords() -> [LearnRecord]? {
        
        guard let realm = tryRealm() else { return nil }
        
        let learnRecords = Array(
            realm.objects(RealmLearnRecord.self)
                .map { $0.convertToNonRealm() }
        )
        
        return learnRecords
    }
    
    static func uploadLearnRecord(learnRecord: LearnRecord) -> Bool {
        
        guard let realm = tryRealm() else { return false }
        
        do {
            try realm.write {
                realm.add(learnRecord.convertToRealm())
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return true
    }
}
