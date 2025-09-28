//import Foundation
//import RealmSwift
//
//extension SheetRealmCruds {
//    
//    static func updateSheetCards(
//        sheetId: String,
//        cards: [Card]
//    ) -> Bool {
//        
//        guard let realm = tryRealm(caller: "updateSheetCards") else { return false }
//        
//        guard let objectId = try? ObjectId(string: sheetId),
//              let sheet = realm
//            .object(ofType: RealmSheet.self, forPrimaryKey: objectId) else {
//            return false
//        }
//        
//        do {
//            try realm.write {
//                sheet.cardList.removeAll()
//                let realmCards = cards.map { $0.convertToRealm() }
//                sheet.cardList.append(objectsIn: realmCards)
//            }
//            return true
//            
//        } catch {
//            print("error: \(error)")
//            return false
//        }
//    }
//}
