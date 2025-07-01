import Foundation


extension CheckRecordRealmCruds {
    
    static func getCheckRecords() -> [CheckRecord]? {
        
        guard let realm = tryRealm(caller: "getCheckRecords") else { return nil }
        
        let checkRecords = Array(
            realm.objects(RealmCheckRecord.self)
                .compactMap { $0.convertToNonRealm() }
        )
        
        return checkRecords
    }
}
