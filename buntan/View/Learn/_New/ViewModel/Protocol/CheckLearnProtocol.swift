import Foundation


protocol CheckLearnProtocol: BaseLearnViewModel {}


extension CheckLearnProtocol {
    
    var estimatedScore: Int {
        
        var fullScore: Double = 0
        var score: Double = 0
        
        for (index, card) in cards.enumerated() {
            
            let cardScore = card.infoList.reduce(0.0) { $0 + ($1.isAnswer ? 3 : 1) }
            
            fullScore += cardScore
            
            if rightCardsIndexList.contains(index) {
                score += cardScore
            }
        }
        return Int((score / fullScore) * EikenGrade.first.questionCount.double)
    }
    
    var isFinished: Bool {
        let cardsCount = leftCardsIndexList.count + rightCardsIndexList.count
        return cardsCount == cards.count
    }
}
