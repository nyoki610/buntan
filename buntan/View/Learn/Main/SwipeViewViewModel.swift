import SwiftUI


class SwipeViewViewModel: ObservableObject {
    
    /// ユーザーの解答入力を受付中かを示す Bool 値
    @Published var isAnswering: Bool = true
    /// ユーザーが解答した選択肢の index
    @Published var selectedIndex: Int = 0
    
    var answerIndex: Int { learnManager.options[learnManager.topCardIndex].firstIndex { learnManager.topCard.word == $0.word } ?? 0 }
    /// 正解かどうかを判断する Bool 値
    var isCorrect: Bool { selectedIndex == answerIndex}
    
    var nextCardExist: Bool { learnManager.topCardIndex < learnManager.cards.count - 1 }
    
    @ObservedObject var learnManager: _LearnManager
    
    init(learnManager: _LearnManager) {
        self.learnManager = learnManager
    }
    
    func onAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.learnManager.readOutTopCard(shouldReadOut: true)
        }
    }
    
    func buttonAction(index: Int, shouldReadOut: Bool, saveAction: @escaping () -> Void) async {
        
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

            await MainActor.run {
                /// 状態更新を少し遅延させることで、ナビゲーション更新の競合を避ける
                /// この処理がないと以下の警告が出る
                /// Update NavigationRequestObserver tried to update multiple times per frame.
                /// Update NavigationAuthority bound path tried to update multiple times per frame.
                learnManager.topCardIndex += 1
                learnManager.readOutTopCard(shouldReadOut: shouldReadOut)
            }
        } else {
            /// animationの完了を待つ
            try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
            saveAction()
        }
    }
}
