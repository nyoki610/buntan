import SwiftUI

class _LearnManager: ObservableObject {
    
    var cards: [Card]
    var options: [[Option]]

    @Published var showSettings: Bool = true
    @Published var topCardIndex: Int = 0
    @Published var animationController: Int = 0
    @Published var rightCardsIndexList: [Int] = []
    @Published var leftCardsIndexList: [Int] = []
    @Published var buttonDisabled: Bool = false
    
    var avSpeaker: AVSpeaker?
    
    init(cards: [Card], options: [[Option]]) {
        
        self.cards = cards
        self.options = options
    }
    
    /// カードの音声読み上げ
    func readOutTopCard(isButton: Bool = false, shouldReadOut: Bool) {
        
        guard (shouldReadOut || isButton) else { return }
        
        let (controllButton, withDelay) = (isButton, !isButton)
        
        guard topCardIndex < cards.count else { return }
        let word = cards[topCardIndex].word
        
        avSpeaker?.readOutText(word,
                               controllButton: controllButton,
                               withDelay: withDelay)
    }
    
    /// 表示中のカードを「完了 or 学習中」に振り分け
    func addIndexToList(_ isCorrect: Bool) -> Void {
        withAnimation(.easeOut(duration: 0.6)) {
            if isCorrect {
                rightCardsIndexList.append(topCardIndex)
            } else {
                leftCardsIndexList.append(topCardIndex)
            }
        }
    }
    
    /// settingsを非表示にする(Swipe, Select, TypeでAnimationを共通にするため関数化)
    func hideSettings() -> Void {
        withAnimation(.easeOut(duration: 0.2)) {
            self.showSettings = false
        }
    }
}


extension _LearnManager {
    
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
}
