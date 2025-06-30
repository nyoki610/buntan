import Foundation


extension CheckRecordRealmAPI {
    
    static func uploadCheckRecord(checkRecord: CheckRecord) -> Bool {
        CheckRecordRealmCruds.uploadCheckRecord(checkRecord: checkRecord)
    }
}
