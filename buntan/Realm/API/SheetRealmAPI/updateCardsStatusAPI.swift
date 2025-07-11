import Foundation


extension SheetRealmAPI {
    
    static func updateCardsStatus(
        viewModel: BaseLearnViewViewModel,
        eikenGrade: EikenGrade,
        bookCategory: BookCategory
    ) -> Bool {
        
        var newStatusTupleList: [(String, Int)] = []
        
        for (index, card) in viewModel.cards.enumerated() {
            
            if viewModel.leftCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, Card.CardStatus.learning.rawValue))
            }
            else if viewModel.rightCardsIndexList.contains(index) {
                newStatusTupleList.append((card.id, Card.CardStatus.completed.rawValue))
            }
        }
        
        return SheetRealmCruds.updateCardsStatus(
            newStatusTupleList: newStatusTupleList,
            bookCategory: bookCategory
        )
    }
}
