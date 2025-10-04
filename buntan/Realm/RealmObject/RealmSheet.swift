import Foundation
import RealmSwift

class RealmSheet: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var gradeRawValue: Double
    @Persisted var cardList: List<RealmCard>
    
    var grade: EikenGrade? {
        EikenGrade(rawValue: gradeRawValue)
    }
}

extension RealmSheet: ConveretableRealmObject {
    
    func convertToNonRealm() -> Sheet? {
        
        guard let grade = grade else {
            print("Error: Failed to convert RealmSheet to Sheet.")
            return nil
        }
        
        return Sheet(id: self.id.stringValue,
                     grade: grade,
                     cardList: self.cardList.compactMap {$0.convertToNonRealm()})
    }
}

extension RealmSheet: NonRealmConvertible {
    
    func toNonRealm() throws -> Sheet {
        guard let grade = grade else {
            throw NonRealmConvertibleError.invalidRawValue
        }
        return Sheet(
            id: id.stringValue,
            grade: grade,
            cardList: cardList.compactMap { $0.convertToNonRealm() }
        )
    }
}
