import Foundation


extension SheetRealmAPI {
    
    static func updateSheetCards(
        grade: EikenGrade,
        newCards: [Card]
    ) -> Bool {
        
        guard confirmTargetSheetExsits(grade: grade) else { return false }
        
        let sheetRepository = SheetRepository()
        guard let sheet: Sheet = try? sheetRepository.getSheet(of: grade) else { return false }
        
        let oldCards: [Card] = sheet.cardList
        let updatedNewCards: [Card] = getUpdatedNewCards(newCards: newCards, oldCards: oldCards)
                
        do {
            try sheetRepository.updateCardList(of: sheet, with: updatedNewCards)
        } catch {
            return false
        }
        
        guard deleteUnnecessaryObjects(oldCards: oldCards) else { return false }
        
        return true
    }
    
    
    private static func confirmTargetSheetExsits(grade: EikenGrade) -> Bool {
        
        let repository = RealmRepository()
        guard let allSheets: [Sheet] = try? repository.fetchAll() else { return false }
        let grades: Set<EikenGrade> = Set(allSheets.map { $0.grade })
        
        if !grades.contains(grade) {
            let sheetUseCase = SheetUseCase()
            do {
                try sheetUseCase.createNewSheet(grade: grade)
            } catch {
                return false
            }
        }
        
        return true
    }
    
    
    private static func getUpdatedNewCards(
        newCards: [Card],
        oldCards: [Card]
    ) -> [Card] {
        
        let oldCardsDict: [String: (Card.CardStatus, Card.CardStatus)] = Dictionary(
            uniqueKeysWithValues: oldCards.map { card in
                (card.word, (card.statusFreq, card.statusPos))
            }
        )
        let updatedNewCards = newCards.map { card in
            var newCard = card
            if let (oldStatusFreq, oldStatusPos) = oldCardsDict[newCard.word] {
                newCard.statusFreq = oldStatusFreq
                newCard.statusPos = oldStatusPos
            }
            return newCard
        }
        
        return updatedNewCards
    }
    
    
    private static func deleteUnnecessaryObjects(oldCards: [Card]) -> Bool {
        
        let unnecessaryCardIds = Set(oldCards.map { $0.id })
        let unnecessaryInfoIds = Set(oldCards.flatMap { $0.infoList.map { $0.id }})
        
        guard SheetRealmCruds.deleteUnnecessaryObjects(
            of: RealmCard.self,
            unnecessaryIds: unnecessaryCardIds
        ) else { return false }
        
        guard SheetRealmCruds.deleteUnnecessaryObjects(
            of: RealmInfo.self,
            unnecessaryIds: unnecessaryInfoIds
        ) else { return false }
        
        return true
    }
}
