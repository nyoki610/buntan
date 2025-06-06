import SwiftUI

extension SelectView {
    
    func onAppearAction() {
        /// 音声クラスを初期化 & 読み上げ
        learnManager.avSpeaker = AVSpeaker($learnManager.buttonDisabled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            learnManager.readOutTopCard()
        }
    }
    
    func buttonAction(_ index: Int) async -> Void {
        
        selectedIndex = index
        
        /// 一時的に isAnswering = false にすることで、解答後の animation を表示
        ///     - 正解の場合 -> 0.3 秒間
        ///     - 不正解の場合 -> 1.0 秒間
        isAnswering = false
        try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
        isAnswering = true
        
        learnManager.addIndexToList(isCorrect)
        
        if nextCardExist {
            learnManager.hideSettings()
            learnManager.topCardIndex += 1
            learnManager.readOutTopCard()
        } else {
            /// animationの完了を待つ
            try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
            saveAction(isBookView: isBookView)
        }
    }
}
