import Foundation


extension SheetRealmAPI {
    
    static func updateCardsStatus(
        learnManager: LearnManager,
        eikenGrade: EikenGrade,
        bookCategory: BookCategory
    ) -> Bool {
        
        var newStatusTupleList: [(String, Int)] = []
        
        for (index, card) in learnManager.cards.enumerated() {
            
            if learnManager.leftCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, CardStatus.learning.rawValue))
            }
            else if learnManager.rightCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, CardStatus.completed.rawValue))
            }
        }
        
        return SheetRealmCruds.updateCardsStatus(
            newStatusTupleList: newStatusTupleList,
            bookCategory: bookCategory
        )
    }
    
    static func _updateCardsStatus(
        learnManager: BookLearnManager,
        eikenGrade: EikenGrade,
        bookCategory: BookCategory
    ) -> Bool {
        
        var newStatusTupleList: [(String, Int)] = []
        
        for (index, card) in learnManager.cards.enumerated() {
            
            if learnManager.leftCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, CardStatus.learning.rawValue))
            }
            else if learnManager.rightCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, CardStatus.completed.rawValue))
            }
        }
        
        return SheetRealmCruds.updateCardsStatus(
            newStatusTupleList: newStatusTupleList,
            bookCategory: bookCategory
        )
    }
}
