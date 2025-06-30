import SwiftUI


protocol BookLearnViewViewModelProtocol: BaseLearnViewViewModel, ObservableObject, AnyObject {
    var nonShuffledCards: [Card] { get }
    var nonShuffledOptions: [[Option]] { get }
}


extension BookLearnViewViewModelProtocol {
    
    internal func shuffleAction(shouldShuffle: Bool) {
        
        topCardIndex = 0
        animationController = 0
        rightCardsIndexList = []
        leftCardsIndexList = []
        
        if shouldShuffle {
            let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
            cards = shuffledArrays.shuffledCards
            options = shuffledArrays.shuffledOptions
        } else {
            cards = nonShuffledCards
            options = nonShuffledOptions
        }
    }
    
    /// 一つ前のカードに戻る処理
    internal func backButtonAction() -> Void {
        
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
    
    internal func backToStart(alertSharedData: AlertSharedData) -> Void {
        
        if topCardIndex > 0 {
            alertSharedData.showSelectiveAlert(
                title: "最初に戻りますか？",
                message: "",
                secondaryButtonLabel: "最初から",
                secondaryButtonType: .defaultButton
            ) {
                while self.topCardIndex > 0 {
                    self.backButtonAction()
                }
            }
        }
    }
}
