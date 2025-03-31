import SwiftUI

class LearnManager: ObservableObject {
    
    @Published var topCardIndex: Int = 0
    @Published var animationController: Int = 0
    @Published var rightCardsIndexList: [Int] = []
    @Published var leftCardsIndexList: [Int] = []
    var cards: [Card] = []
    var options: [[Option]] = []
    
    @Published var shouldShuffle: Bool = false
    @Published var showInitial: Bool = false
    @Published var showSentence: Bool = true
    @Published var isKeyboardActive: Bool = false
    
    @Published var shouldReadOut: Bool = true
    @Published var buttonDisabled: Bool = false
    var avSpeaker: AVSpeaker?
    
    /// Learn開始前に必ず初期化
    /// Learn終了後の初期化は無し
    /// →ResultViewで各プロパティは使用可能
    func setupLearn(_ cards: [Card], _ options: [[Option]]) -> Void {

        topCardIndex = 0
        animationController = 0
        rightCardsIndexList = []
        leftCardsIndexList = []
        
        self.cards = cards
        self.options = options
        
        if shouldShuffle {
            
            let indices = Array(0..<cards.count).shuffled()
            
            self.cards = indices.map { cards[$0] }
            self.options = indices.map { options[$0] }
        }
    }
    
    /// カードの音声読み上げ
    func readOutTopCard(isButton: Bool = false) {
        
        guard (shouldReadOut || isButton) else { return }
        
        let (controllButton, withDelay) = (isButton, !isButton)
        
        guard topCardIndex < cards.count else { return }
        let word = cards[topCardIndex].word
        
        avSpeaker?.readOutText(word,
                               controllButton: controllButton,
                               withDelay: withDelay)
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
}
