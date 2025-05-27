import SwiftUI

extension SwipeView {
    
    func onAppearAction() {

        /// 単語カードの位置を中央へ
        self.offset = .zero
        
        /// 音声クラスを初期化 & 読み上げ
        learnManager.avSpeaker = AVSpeaker($learnManager.buttonDisabled)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            learnManager.readOutTopCard()
        }
    }
    
    /// modifier for dragGesture
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
        
        /// to width にカード位置を調整する関数
        func animateCardFlip(to width: CGFloat) {
            /// iPadでは画面サイズが大きい分, アニメーション時間を長くする
            /// iPhoneとiPadでカード遷移速度は同じ
            withAnimation(.linear(duration: responsiveSize(0.2, 0.4))) {
                self.offset.width = width
            }
        }
        
        /// 次の単語カードに移る関数
        func goNext() async {
            try? await Task.sleep(nanoseconds: 0_200_000_000)
            learnManager.hideSettings()
            self.isFlipped = false
            self.isFlippedWithNoAnimation = false
            self.offset.width = 0
            learnManager.topCardIndex += 1
            learnManager.animationController += 1
            learnManager.readOutTopCard()
        }
        
        /// drag 距離が 100 より大きい場合は次の単語へ
        if abs(self.offset.width) > 100 {
            learnManager.addIndexToList(self.offset.width > 0)
            let offsetAbs = responsiveSize(300, 600)
            animateCardFlip(to: self.offset.width > 0 ? offsetAbs : -offsetAbs)

            if nextCardExist {
                await goNext()
            } else {
                /// animationの完了を待つ
                try? await Task.sleep(nanoseconds: 0_300_000_000)
                saveAction(isBookView: true)
            }
        /// drag 距離が 100 以下の場合は offset を 0 に戻すのみ
        } else {
            animateCardFlip(to: 0)
        }
    }
}
