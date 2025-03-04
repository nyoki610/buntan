import Foundation
import RealmSwift

class Info: Identifiable {
    let id: String
    let year: Int
    let time: Int
    let isAnswer: Bool
    
    init(id: String, year: Int, time: Int, isAnswer: Bool) {
        self.id = id
        self.year = year
        self.time = time
        self.isAnswer = isAnswer
    }
    
    func convertToRealm() -> RealmInfo {
        let realmInfo = RealmInfo()
        realmInfo.year = year
        realmInfo.time = time
        realmInfo.isAnswer = isAnswer
        return realmInfo
    }
}

