import Foundation


class CheckRecordRealmCruds: RealmCruds {
    
    static func getCheckRecords() -> [CheckRecord]? {
        
        guard let realm = tryRealm() else { return nil }
        
        let checkRecords = Array(
            realm.objects(RealmCheckRecord.self)
                .compactMap { $0.convertToNonRealm() }
        )
        
        return checkRecords
    }
    
    static func uploadCheckRecord(checkRecord: CheckRecord) -> Bool {
        
        guard let realm = tryRealm() else { return false }
        
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
