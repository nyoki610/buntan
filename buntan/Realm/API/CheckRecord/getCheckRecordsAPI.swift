import Foundation


extension CheckRecordRealmAPI {
    
    static func getCheckRecords() -> [CheckRecord]? {
        CheckRecordRealmCruds.getCheckRecords()
    }
}
