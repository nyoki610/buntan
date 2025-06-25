import SwiftUI


class BookLearnManager: _LearnManager {
    
    private let nonShuffledCards: [Card]
    private let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool) {
        
        let indices = Array(0..<cards.count).shuffled()

        let cards = shouldShuffle ? indices.map { cards[$0] } : cards
        let options = shouldShuffle ? indices.map { options[$0] } : options
        
        self.init(cards: cards, options: options, nonShuffledCards: cards, nonShuffledOptions: options)
    }
    
    init(cards: [Card], options: [[Option]], nonShuffledCards: [Card], nonShuffledOptions: [[Option]]) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        super.init(cards: cards, options: options)
    }
    
    func resetLearning(shouldShuffle: Bool) {
        
        topCardIndex = 0
        animationController = 0
        rightCardsIndexList = []
        leftCardsIndexList = []
        
        if shouldShuffle {
            let shuffledArrays = getShuffledArrays()
            cards = shuffledArrays.cards
            options = shuffledArrays.options
        } else {
            cards = nonShuffledCards
            options = nonShuffledOptions
        }
    }
    
    private func getShuffledArrays() -> (cards: [Card], options: [[Option]]) {
        
        let indices = Array(0..<nonShuffledCards.count).shuffled()
        
        let shuffledCards = indices.map { nonShuffledCards[$0] }
        let shuffledOptions = indices.map { nonShuffledOptions[$0] }
        
        return (shuffledCards, shuffledOptions)
    }
    
    /// 一つ前のカードに戻る処理
    func backButtonAction() -> Void {
        
        guard topCardIndex > 0 else { return }
        
        withAnimation(.easeOut(duration: 0.4)) {
            self.topCardIndex -= 1
        }
        self.animationController -= 1
        
        if self.rightCardsIndexList.contains(self.topCardIndex) {
            self.rightCardsIndexList.removeLast()
        }
        if self.leftCardsIndexList.contains(self.topCardIndex) {
            self.leftCardsIndexList.removeLast()
        }
    }
}

