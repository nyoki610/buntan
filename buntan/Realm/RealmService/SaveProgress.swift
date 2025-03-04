import Foundation


extension RealmService {
    
    func saveProgress(_ learnManager: LearnManager, _ grade: Eiken, _ bookType: BookType) -> [[Book]]? {
        
        guard let index = sheets.firstIndex(where: { $0.grade == grade }) else { return nil }
        let savedSheet = sheets[index]
        
        for (i, card) in learnManager.cards.enumerated() {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return nil }
            
            if learnManager.leftCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookType, .learning)
            }
            
            if learnManager.rightCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookType, .completed)
            }
        }
        
        guard synchronizeSheet(savedSheet) else { return nil }
        sheets[index] = savedSheet
        
        return setupBooksList()
    }
    
    func resetProgress(_ cards: [Card], _ grade: Eiken, _ bookType: BookType) -> [[Book]]? {
            
        guard let index = sheets.firstIndex(where: { $0.grade == grade }) else { return nil }
        
        let savedSheet = sheets[index]
        
        for card in cards {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return nil }
            savedSheet.cardList[index].toggleStatus(bookType, .notLearned)
        }
        
        guard synchronizeSheet(savedSheet) else { return nil }
        sheets[index] = savedSheet
        
        return setupBooksList()
    }
}
