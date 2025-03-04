import SwiftUI

extension SwipeView {
    
    func onAppearAction() {

        self.offset = .zero
        learnManager.avSpeaker = AVSpeaker($learnManager.buttonDisabled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            learnManager.readOutTopCard()
        }
    }
    
    func dragGesture(for index: Int) -> some Gesture {
        
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeOut(duration: 0.2)) {
                    self.offset = gesture.translation
                }
            }
            .onEnded { _ in
                Task {
                    await onEndedAction(index)
                }
            }
    }
    
    func onEndedAction(_ index: Int) async {
        
        func animateCardFlip(to width: CGFloat) {
            withAnimation(.linear(duration: 0.2)) {
                self.offset.width = width
            }
        }
        
        func goNext() async {
            try? await Task.sleep(nanoseconds: 0_200_000_000)
            self.isFlipped = false
            self.offset.width = 0
            learnManager.topCardIndex += 1
            learnManager.animationController += 1
            learnManager.readOutTopCard()
        }
        
        if abs(self.offset.width) > 100 {
            learnManager.addIndexToList(self.offset.width > 0)
            animateCardFlip(to: self.offset.width > 0 ? 300 : -300)

            if nextCardExist {
                await goNext()
            } else {
                /// animationの完了を待つ
                try? await Task.sleep(nanoseconds: 0_300_000_000)
                saveAction(isBookView: true)
            }
        } else {
            animateCardFlip(to: 0)
        }
    }
}
