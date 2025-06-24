import SwiftUI

class CheckLearnManager: _LearnManager {
    
}

class BookLearnManager: _LearnManager {
    
    private let nonShuffledCards: [Card]
    private let nonShuffledOptions: [[Option]]
    
    @Published var isKeyboardActive: Bool = false
    
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
