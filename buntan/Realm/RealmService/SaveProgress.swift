import Foundation


extension RealmService {
    
    func saveProgress(_ learnManager: LearnManager, _ grade: EikenGrade, _ bookCategory: BookCategory) -> Bool {
        
        guard let savedSheet = sheetDict[grade] else { return false }
        
        for (i, card) in learnManager.cards.enumerated() {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return false }
            
            if learnManager.leftCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookCategory, .learning)
            }
            
            if learnManager.rightCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookCategory, .completed)
            }
        }
        
        guard synchronizeSheet(savedSheet) else { return false }
        sheetDict[grade] = savedSheet
        
        setupBooksDict()
        
        return true
    }
    
    func resetProgress(_ cards: [Card], _ grade: EikenGrade, _ bookCategory: BookCategory) -> Bool {
            
        guard let savedSheet = sheetDict[grade] else { return false }
        
        for card in cards {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return false }
            savedSheet.cardList[index].toggleStatus(bookCategory, .notLearned)
        }
        
        guard synchronizeSheet(savedSheet) else { return false }
        sheetDict[grade] = savedSheet
        
        setupBooksDict()
        
        return true
    }
}
