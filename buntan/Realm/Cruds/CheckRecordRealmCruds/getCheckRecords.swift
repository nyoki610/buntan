import Foundation


extension CheckRecordRealmCruds {
    
    static func getCheckRecords() -> [CheckRecord]? {
        
        guard let realm = tryRealm() else { return nil }
        
        let checkRecords = Array(
            realm.objects(RealmCheckRecord.self)
                .compactMap { $0.convertToNonRealm() }
        )
        
        return checkRecords
    }
}
