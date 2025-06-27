import SwiftUI

class BaseLearnViewModel: ObservableObject {
    
    var cards: [Card]
    var options: [[Option]]

    @Published var showSetting: Bool = true
    @Published var topCardIndex: Int = 0
    @Published var animationController: Int = 0
    @Published var rightCardsIndexList: [Int] = []
    @Published var leftCardsIndexList: [Int] = []
    @Published var buttonDisabled: Bool = false

    /// 音声が正しく再生されるかの確認必須？
    private var avSpeaker = AVSpeaker()
    
    var topCard: Card { topCardIndex < cards.count ?  cards[topCardIndex] : EmptyModel.card }
    var nextCardExist: Bool { topCardIndex < cards.count - 1 }
    var learnedCardsCount: Int { leftCardsIndexList.count + rightCardsIndexList.count }
    
    init(cards: [Card], options: [[Option]]) {
        
        self.cards = cards
        self.options = options
        
        // 学習状態を明示的にリセット
        self.showSetting = true
        self.topCardIndex = 0
        self.animationController = 0
        self.rightCardsIndexList = []
        self.leftCardsIndexList = []
        self.buttonDisabled = false
    }
    
    /// カードの音声読み上げ
    func readOutTopCard(isButton: Bool = false, shouldReadOut: Bool) {
        
        guard (shouldReadOut || isButton) else { return }
        
        let (controllButton, withDelay) = (isButton, !isButton)
        
        guard topCardIndex < cards.count else { return }
        let word = cards[topCardIndex].word
        
        avSpeaker.readOutText(
            word,
            controllButton: controllButton,
            withDelay: withDelay
        )
    }
    
    /// 表示中のカードを「完了 or 学習中」に振り分け
    func addIndexToList(_ isCorrect: Bool) -> Void {
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.6)) {
                if isCorrect {
                    self.rightCardsIndexList.append(self.topCardIndex)
                } else {
                    self.leftCardsIndexList.append(self.topCardIndex)
                }
            }
        }
    }
    
    /// 必要? commented at 2025/06/25
    /// settingsを非表示にする(Swipe, Select, TypeでAnimationを共通にするため関数化)
    func hideSettings() -> Void {
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.2)) {
                self.showSetting = false
            }
        }
    }
}
