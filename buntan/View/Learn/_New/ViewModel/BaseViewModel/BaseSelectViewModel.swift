import Foundation


class BaseSelectViewModel: BaseLearnViewModel {
    
    /// ユーザーの解答入力を受付中かを示す Bool 値
    @Published var isAnswering: Bool = true
    /// ユーザーが解答した選択肢の index
    @Published var selectedIndex: Int = 0
    
    var answerIndex: Int { options[topCardIndex].firstIndex { topCard.word == $0.word } ?? 0 }
    /// 正解かどうかを判断する Bool 値
    var isCorrect: Bool { selectedIndex == answerIndex}

    func onAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.readOutTopCard(shouldReadOut: true)
        }
    }
    
    func passAction(
        shouldReadOut: Bool,
        saveAction: @escaping () -> Void
    ) {
        optionButtonAction(
            selectedOptionIndex: -1,
            shouldReadOut: shouldReadOut,
            saveAction: saveAction
        )
    }
    
    func optionButtonAction(
        selectedOptionIndex: Int,
        shouldReadOut: Bool,
        saveAction: @escaping () -> Void
    ) {
        
        Task {
            await chooseOption(
                selectedOptionIndex: selectedOptionIndex,
                shouldReadOut: shouldReadOut
            )
            if !nextCardExist {
                /// animationの完了を待つ
                try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
                
                saveAction()
            }
        }
    }
    
    func chooseOption(
        selectedOptionIndex: Int,
        shouldReadOut: Bool
    ) async {
        
        selectedIndex = selectedOptionIndex
        
        /// 一時的に isAnswering = false にすることで、解答後の animation を表示
        ///     - 正解の場合 -> 0.3 秒間
        ///     - 不正解の場合 -> 1.0 秒間
        isAnswering = false
        try? await Task.sleep(nanoseconds: isCorrect ? 0_300_000_000 : 1_000_000_000)
        isAnswering = true
        
        addIndexToList(isCorrect)
        
        hideSettings()

        guard nextCardExist else { return }
        
        await MainActor.run {
            /// 状態更新を少し遅延させることで、ナビゲーション更新の競合を避ける
            /// この処理がないと以下の警告が出る
            /// Update NavigationRequestObserver tried to update multiple times per frame.
            /// Update NavigationAuthority bound path tried to update multiple times per frame.
            topCardIndex += 1
            readOutTopCard(shouldReadOut: shouldReadOut)
        }
    }
}
