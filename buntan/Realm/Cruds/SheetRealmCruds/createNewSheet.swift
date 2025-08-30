import Foundation
import RealmSwift


extension SheetRealmCruds {
    
    static func createNewSheet(grade: EikenGrade) -> Bool {
        
        guard let realm = tryRealm(caller: "createNewSheet") else { return false }
        let newRealmSheet = RealmSheet()
        newRealmSheet.gradeRawValue = grade.rawValue
        newRealmSheet.cardList = List()
        
        do {
            try realm.write {
                realm.add(newRealmSheet)
            }
            return true
        } catch {
            print("error: \(error)")
            return false
        }
    }
}
