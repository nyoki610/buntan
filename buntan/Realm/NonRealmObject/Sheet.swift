import Foundation
import RealmSwift

class Sheet {
    let id: String
    let grade: Eiken
    var cardList: [Card]
    
    init(id: String, grade: Eiken, cardList: [Card]) {
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
