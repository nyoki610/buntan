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

        /// avoid index out of range
        guard topCardIndex > 0 else { return }
        
        let targetIndex = topCardIndex - 1
        
        withAnimation(.easeOut(duration: 0.4)) {
            if let rightIndex = self.rightCardsIndexList.firstIndex(of: targetIndex) {
                self.rightCardsIndexList.remove(at: rightIndex)
            } else if let leftIndex = self.leftCardsIndexList.firstIndex(of: targetIndex) {
                self.leftCardsIndexList.remove(at: leftIndex)
            } else {
                /// right, leftのどちらにも存在しない場合はtopCardIndexの更新を行わずにreturn
                return
            }
        }
        
        withAnimation(.easeOut(duration: 0.4)) {
            self.topCardIndex = targetIndex
        }
        self.animationController -= 1
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
