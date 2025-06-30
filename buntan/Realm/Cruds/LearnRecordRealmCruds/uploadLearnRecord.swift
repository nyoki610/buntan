import Foundation


extension LearnRecordRealmCruds {
    
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
