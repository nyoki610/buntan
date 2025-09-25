import Foundation


extension BookLearnViewViewModelProtocol {
    
    @MainActor
    internal func bookLearnSaveAction(
        navigator: BookNavigator,
        loadingManager: LoadingManager,
        bookUserInput: BookUserInput,
        learnedCardsCount: Int
    ) async {

        /// ↓この処理は必要？ @2025/06/29
        /// Keyboard を非表示 (for TypeView())
        if let typLearnManager = self as? BookTypeViewViewModel {
            DispatchQueue.main.async {
                typLearnManager.isKeyboardActive = false
            }
        }
        
        /// loading を開始
        await loadingManager.startLoading(.save)

        /// ensure loading screen rendering by delaying the next process
        let delay: UInt64 = 100_000_000
        try? await Task.sleep(nanoseconds: delay)

        guard self.updateCardsStatus(userInput: bookUserInput) else { return }

        guard self.uploadLearnRecord() else { return }

        /// loading を終了して画面遷移
        await loadingManager.finishLoading()

        guard self.tnrasitionScreen(
            userInput: bookUserInput,
            navigator: navigator,
            learnedCardCount: learnedCardsCount
        ) else {
            /// エラーハンドリングが必要？
            return
        }
    }

    private func updateCardsStatus(userInput: BookUserInput) -> Bool {

        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory else { return false }
        
        /// 学習内容を realm に保存
        guard SheetRealmAPI.updateCardsStatus(
            viewModel: self,
            eikenGrade: selectedGrade,
            bookCategory: selectedBookCategory
        ) else { return false }
        
        return true
    }
    
    private func uploadLearnRecord() -> Bool {
        
        /// 学習量の記録を保存
        let learnRecord = LearnRecord(
            id: UUID().uuidString,
            date: Date(),
            learnedCardCount: learnedCardsCount
        )
        
        try? learnRecordUseCase.uploadLearnRecord(record: learnRecord)
        
        return true
    }
    
    private func tnrasitionScreen(
        userInput: BookUserInput,
        navigator: BookNavigator,
        learnedCardCount: Int
    ) -> Bool {
        
        guard let cardsContainer = CardsContainer(userInput: userInput) else { return false }
        
        /// 「学習を最後まで進めてから save しようとしているか」を判断
        let isFinished = (learnedCardsCount == cards.count)
        
        if isFinished {
            navigator.push(.learnResult(cardsContainer, learnedCardCount))
        } else {
            navigator.pop(to: .sectionList(EmptyModel.book))
            navigator.push(.learnSelect(cardsContainer))
        }
        
        return true
    }
}
