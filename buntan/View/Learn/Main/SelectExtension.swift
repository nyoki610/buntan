import SwiftUI

extension SelectView {
    
    func onAppearAction() {
        learnManager.avSpeaker = AVSpeaker($learnManager.buttonDisabled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            learnManager.readOutTopCard()
        }
    }
    
    func buttonAction(_ index: Int) async -> Void {
        
        selectedIndex = index
        isAnswering = false
        
        try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
        isAnswering = true
        
        learnManager.addIndexToList(isCorrect)
        
        if nextCardExist {
            learnManager.topCardIndex += 1
            learnManager.readOutTopCard()
        } else {
            /// animationの完了を待つ
            try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
            saveAction(isBookView: isBookView)
        }
    }
}
