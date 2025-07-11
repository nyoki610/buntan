import Foundation


extension CheckRecordRealmCruds {

    static func uploadCheckRecord(checkRecord: CheckRecord) -> Bool {
        
        guard let realm = tryRealm(caller: "uploadCheckRecord") else { return false }
        
        do {
            try realm.write {
                realm.add(checkRecord.convertToRealm())
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return true
    }
}
