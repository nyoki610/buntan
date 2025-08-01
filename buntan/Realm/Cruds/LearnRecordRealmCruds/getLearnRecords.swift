import Foundation


extension LearnRecordRealmCruds {
    
    static func getLearnRecords() -> [LearnRecord]? {
        
        guard let realm = tryRealm(caller: "getLearnRecords") else { return nil }
        
        let learnRecords = Array(
            realm.objects(RealmLearnRecord.self)
                .map { $0.convertToNonRealm() }
        )
        
        return learnRecords
    }
}
