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

extension Info: RealmConvertible {
    
    func toRealm(with idType: RealmIdType) throws -> RealmInfo {
        let realmInfo = RealmInfo()
        try setId(to: realmInfo, idType: idType)
        realmInfo.year = year
        realmInfo.time = time
        realmInfo.isAnswer = isAnswer
        return realmInfo
    }
}
