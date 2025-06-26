import SwiftUI


class BaseSwipeViewModel: BaseLearnViewModel {

    @Published var offset = CGSize.zero
    @Published var isFlipped: Bool = false
    @Published var isFlippedWithNoAnimation: Bool = false

    var nonAnimationCard: Card { animationController < cards.count ? cards[animationController] : EmptyModel.card }
}

extension BaseSwipeViewModel {
    
    func onAppearAction(shouldReadOut: Bool) {

        /// 単語カードの位置を中央へ
        self.offset = .zero
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.readOutTopCard(shouldReadOut: shouldReadOut)
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
    ) async {
        
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
                self.isFlipped = false
                self.isFlippedWithNoAnimation = false
                self.offset.width = 0
                self.topCardIndex += 1
                self.animationController += 1
            }
            readOutTopCard(shouldReadOut: sholdReadOut)
        }
        
        /// drag 距離が 100 より大きい場合は次の単語へ
        if abs(self.offset.width) > 100 {
            addIndexToList(self.offset.width > 0)
            await animateCardFlip(to: self.offset.width > 0 ? offsetAbs : -offsetAbs)
            
            guard nextCardExist else { return }
            
            await goNext()
        /// drag 距離が 100 以下の場合は offset を 0 に戻すのみ
        } else {
            await animateCardFlip(to: 0)
        }
    }
}
