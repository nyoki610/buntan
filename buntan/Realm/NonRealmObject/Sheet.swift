import Foundation
import RealmSwift

struct Sheet {
    let id: String
    let grade: EikenGrade
    var cardList: [Card]
    
    init(id: String, grade: EikenGrade, cardList: [Card]) {
        self.id = id
        self.grade = grade
        self.cardList = cardList
    }
    
    func extractCards(_ indexList: [Int]) -> [Card] {
        cardList.filter { indexList.contains($0.index) }
    }
    
    func convertToRealm() -> RealmSheet {
        
        let realmSheet = RealmSheet()

        realmSheet.gradeRawValue = self.grade.rawValue
        
        let realmCardList = List<RealmCard>()
        for card in cardList {
            realmCardList.append(card.convertToRealm())
        }
        realmSheet.cardList = realmCardList

        return realmSheet
    }
}

extension Sheet: RealmConvertible {
    
    func toRealm(with idType: RealmIdType) throws -> RealmSheet {
        let realmSheet = RealmSheet()
        try setId(to: realmSheet, idType: idType)
        realmSheet.gradeRawValue = grade.rawValue
        realmSheet.cardList = try getRealmCardList(from: cardList, with: idType)
        return realmSheet
    }
    
    private func getRealmCardList(from cardList: [Card], with idType: RealmIdType) throws -> List<RealmCard> {
        let realmCards = try cardList.map { try $0.toRealm(with: idType) }
        let realmCardList = List<RealmCard>()
        realmCardList.append(objectsIn: realmCards)
        return realmCardList
    }
}

struct SheetFactory {
    
    static func createNew(from grade: EikenGrade) -> Sheet {
        return Sheet(
            /// This id should be overwritten when inserted to realm
            id: UUID().uuidString,
            grade: grade,
            cardList: []
        )
    }
}
