import SwiftUI

class CheckSharedData: ObservableObject {
    
    @Published var path: [ViewName] = []
    
    @Published var booksList: [[Book]] = []
    @Published var selectedGrade: Eiken = .first

    var cards: [Card] = []
    
    func extractCards() {
        guard let extractedCards = selectedGrade.extractForCheck(booksList) else { return }
        cards = extractedCards
    }

    func estimatedScore(_ learningManager: LearnManager) -> Int {
        
        var fullScore: Double = 0
        var score: Double = 0
        
        for (index, card) in cards.enumerated() {
            
            let cardScore = card.infoList.reduce(0.0) { $0 + ($1.isAnswer ? 3 : 1) }
            
            fullScore += cardScore
            
            if learningManager.rightCardsIndexList.contains(index) {
                score += cardScore
            }
        }
        return Int((score / fullScore) * Eiken.first.questionCount.double)
    }
}
