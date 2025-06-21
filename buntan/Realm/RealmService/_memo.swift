import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    
    /// RealmService
    func tryRealm() -> Realm?
    func setupRealmFile()

    /// SheetHandler
    var sheetDict: [EikenGrade: Sheet] { get set }
    var booksDict: [EikenGrade: [BookDesign: Book]]? { get set }
    
    func synchronizeSheet(_ sheet: Sheet) -> Bool
//    guard
//        let realm = tryRealm(),
//        let objectId = try? ObjectId(string: sheet.id),
//        let targetSheet = realm.object(ofType: RealmSheet.self, forPrimaryKey: objectId) else { return false }
//    
//    do {
//        try realm.write {
//            targetSheet.cardList = sheet.convertToRealm().cardList
//        }
//        return true
//            
//    } catch {
//        print("Error: \(error.localizedDescription)")
//        return false
//    }
    
    func saveProgress(_ learnManager: LearnManager, _ grade: EikenGrade, _ bookCategory: BookCategory) -> [EikenGrade: [BookDesign: Book]]?
    func resetProgress(_ cards: [Card], _ grade: EikenGrade, _ bookCategory: BookCategory) -> [EikenGrade: [BookDesign: Book]]?
    
    
    /// RecordHandler
    var learnRecords: [LearnRecord] { get set }
    var checkRecords: [CheckRecord] { get set }
    var combinedRecords: [LearnRecord] { get set }

    func convertGradeToSheet(_ grade: EikenGrade) -> Sheet?

    func fetchRealmObjects()
    func synchronizeRecord(learnRecord: LearnRecord?, checkRecord: CheckRecord?)
}
