import Foundation


enum CheckRecordRealmAPI {
    
    static func getCheckRecords() -> [CheckRecord]? {
        CheckRecordRealmCruds.getCheckRecords()
    }
    
    static func uploadCheckRecord(checkRecord: CheckRecord) -> Bool {
        CheckRecordRealmCruds.uploadCheckRecord(checkRecord: checkRecord)
    }
}
