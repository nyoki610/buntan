import Foundation
import RealmSwift

extension SheetRealmCruds {
    
    static func resetCardStatus(
        cardIdList: [String],
        bookCategory: BookCategory
    ) -> Bool {
        
        guard let realm = tryRealm(caller: "resetCardStatus") else { return false }
        
        do {
            try realm.write {
                for cardId in cardIdList {
                    guard let objectId = try? ObjectId(string: cardId),
                          let targetCard = realm.object(ofType: RealmCard.self, forPrimaryKey: objectId) else {
                        continue
                    }

                    switch bookCategory {
                    case .freq:
                        targetCard.statusFreqRawValue = CardStatus.notLearned.rawValue
                    case .pos:
                        targetCard.statusPosRawValue = CardStatus.notLearned.rawValue
                    }
                }
            }
            return true
        } catch {
            return false
        }
    }
}
