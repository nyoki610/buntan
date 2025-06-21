import Foundation
import RealmSwift

final class SheetHandler {
    
    var firstGradeCards: [Card]
    var preFirstGradeCards: [Card]

    init?(realm: Realm) {
        
        /// get all sheets from realm
        let realmSheets: Results<RealmSheet> = realm.objects(RealmSheet.self)
        
        /// convert all RealmSheet to Sheet
        var sheets: [Sheet] = []
        
        for realmSheet in realmSheets {
            guard let sheet = realmSheet.convertToNonRealm() else {
                return nil
            }
            sheets.append(sheet)
        }
        
        /// check if sheets count is equal to EikenGrade.allCases.count
        guard sheets.count == EikenGrade.allCases.count else {
            return nil
        }
        
        /// get first grade sheet
        guard let firstGradeSheet = sheets.first(where: { $0.grade == .first }) else {
            return nil
        }
        
        /// get pre first grade sheet
        guard let preFirstGradeSheet = sheets.first(where: { $0.grade == .preFirst }) else {
            return nil
        }
        
        self.firstGradeCards = firstGradeSheet.cardList
        self.preFirstGradeCards = preFirstGradeSheet.cardList
    }
}
