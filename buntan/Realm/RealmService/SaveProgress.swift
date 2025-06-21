import Foundation


extension RealmService {
    
    func saveProgress(_ learnManager: LearnManager, _ grade: EikenGrade, _ bookCategory: BookCategory) -> [EikenGrade: [BookDesign: Book]]? {
        
        guard let savedSheet = sheetDict[grade] else { return nil }
        
        for (i, card) in learnManager.cards.enumerated() {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return nil }
            
            if learnManager.leftCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookCategory, .learning)
            }
            
            if learnManager.rightCardsIndexList.contains(i) {
                savedSheet.cardList[index].toggleStatus(bookCategory, .completed)
            }
        }
        
        guard synchronizeSheet(savedSheet) else { return nil }
        sheetDict[grade] = savedSheet
        
        return booksDict
    }
    
    func resetProgress(_ cards: [Card], _ grade: EikenGrade, _ bookCategory: BookCategory) -> [EikenGrade: [BookDesign: Book]]? {
            
        guard let savedSheet = sheetDict[grade] else { return nil }
        
        for card in cards {
            
            guard let index = savedSheet.cardList.firstIndex(where: { $0.index == card.index }) else { return nil }
            savedSheet.cardList[index].toggleStatus(bookCategory, .notLearned)
        }
        
        guard synchronizeSheet(savedSheet) else { return nil }
        sheetDict[grade] = savedSheet
        
        return booksDict
    }
}
