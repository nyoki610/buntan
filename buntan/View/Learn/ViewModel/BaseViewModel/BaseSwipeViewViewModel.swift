import SwiftUI


class BaseSwipeViewViewModel: BaseLearnViewViewModel {

    @Published var offset = CGSize.zero
    @Published var isWordCardFlipped: Bool = false
    @Published var isWordCardFlippedWithNoAnimation: Bool = false
    @Published var isSentenceCardFlipped: Bool = false
    @Published var isSentenceCardFlippedWithNoAnimation: Bool = false

    var nonAnimationCard: Card { animationController < cards.count ? cards[animationController] : EmptyModel.card }
}

extension BaseSwipeViewViewModel {
    
    func onAppearAction(shouldReadOut: Bool) {
        
        if shouldReadOut {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.readOutTopCard(withDelay: true)
            }
        }
    }
    
    /// modifier for dragGesture
    func dragGesture(
        onEndeadAction: @escaping () -> Void
    ) -> some Gesture {
        
        DragGesture()
            .onChanged { gesture in
                withAnimation(.easeOut(duration: 0.2)) {
                    self.offset = gesture.translation
                }
            }
            .onEnded { _ in
                onEndeadAction()
            }
    }
    
    func onEndedAction(
        index: Int,
        animationDuration: CGFloat,
        offsetAbs: CGFloat,
        sholdReadOut: Bool
        /// shouldSave: Bool
    ) async -> Bool {
        
        /// to width にカード位置を調整する関数
        func animateCardFlip(to width: CGFloat) async {
            /// iPadでは画面サイズが大きい分, アニメーション時間を長くする
            /// iPhoneとiPadでカード遷移速度は同じ
            await MainActor.run {
                withAnimation(.linear(duration: animationDuration)) {
                    self.offset.width = width
                }
            }
        }
        
        /// 次の単語カードに移る関数
        func goNext() async {
            try? await Task.sleep(nanoseconds: 0_200_000_000)
            hideSettings()
            await MainActor.run {
                self.isWordCardFlipped = false
                self.isWordCardFlippedWithNoAnimation = false
                self.isSentenceCardFlipped = false
                self.isSentenceCardFlippedWithNoAnimation = false
                self.offset.width = 0
                self.topCardIndex += 1
                self.animationController += 1
            }
            if sholdReadOut {
                readOutTopCard(withDelay: true)
            }
        }
        
        /// drag 距離が 100 より大きい場合は次の単語へ
        if abs(self.offset.width) > 100 {
            let isCorrect = self.offset.width > 0
            addIndexToList(isCorrect: isCorrect)
            await animateCardFlip(to: self.offset.width > 0 ? offsetAbs : -offsetAbs)
            
            guard nextCardExist else { return true }
            
            await goNext()
            
            return false
        /// drag 距離が 100 以下の場合は offset を 0 に戻すのみ
        } else {
            await animateCardFlip(to: 0)
            return false
        }
    }
}
