import Foundation
import RealmSwift

extension Info: RealmConvertable {
    
    func convertToRealm() -> RealmInfo {
        let realmInfo = RealmInfo()
        realmInfo.year = year
        realmInfo.time = time
        realmInfo.isAnswer = isAnswer
        return realmInfo
    }
}
