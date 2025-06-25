import Foundation


extension BookLearnViewProtocol {
    
    internal func shuffleAction() -> Void {
        
        if learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count == 0 {
            
            executeShuffle()
        } else {
            showShuffleAlert() {
                executeShuffle()
            }
        }
    }
    
    private func showShuffleAlert(executeShuffle: @escaping () -> Void) -> Void {
        
        var title = "現在の進捗はリセットされます\n"
        title += userDefaultHandler.shouldShuffle ? "元に戻" : "シャッフル"
        title += "しますか？"
        
        let secondaryButtonLabel = userDefaultHandler.shouldShuffle ? "元に戻す" : "シャッフル"
        
        alertSharedData.showSelectiveAlert(
            title: title,
            message: "",
            secondaryButtonLabel: secondaryButtonLabel,
            secondaryButtonType: .defaultButton
        ) {
            executeShuffle()
        }
    }
    
    private func executeShuffle() {
        
        userDefaultHandler.shouldShuffle.toggle()
        learnManager.resetLearning(shouldShuffle: userDefaultHandler.shouldShuffle)
    }
}
