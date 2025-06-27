import Foundation


extension BookLearnViewViewModelProtocol {
    
    internal func bookLearnSaveAction(
        pathHandler: BookViewPathHandler,
        loadingSharedData: LoadingSharedData,
        bookUserInput: BookUserInput,
        learnedCardsCount: Int
    ) {

        /// Keyboard を非表示 (for TypeView())
//        if let typLearnManager = self as? BookTypeViewViewModel {
//            typLearnManager.isKeyboardActive = false
//        }
        
        /// loading を開始
        loadingSharedData.startLoading(.save)

        /// ensure loading screen rendering by delaying the next process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard self.updateCardsStatus(userInput: bookUserInput) else { return }
            
            guard self.uploadLearnRecord() else { return }
            
            /// loading を終了して画面遷移
            loadingSharedData.finishLoading {
                guard self.tnrasitionScreen(
                    userInput: bookUserInput,
                    pathHandler: pathHandler,
                    learnedCardCount: learnedCardsCount
                ) else { return }
            }
        }
    }

    private func updateCardsStatus(userInput: BookUserInput) -> Bool {

        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory else { return false }
        
        /// 学習内容を realm に保存
        guard SheetRealmAPI._updateCardsStatus(
            viewModel: self,
            eikenGrade: selectedGrade,
            bookCategory: selectedBookCategory
        ) else { return false }
        
        return true
    }
    
    private func uploadLearnRecord() -> Bool {
        
        /// 学習量の記録を保存
        let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                      learnedCardsCount)
        
        guard LearnRecordRealmAPI.uploadLearnRecord(learnRecord: learnRecord) else { return false }
        
        return true
    }
    
    private func tnrasitionScreen(
        userInput: BookUserInput,
        pathHandler: BookViewPathHandler,
        learnedCardCount: Int
    ) -> Bool {

        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory,
              let selectedBookConfig = userInput.selectedBookConfig,
              let selectedSectionTitle = userInput.selectedSectionTitle else { return false }
        
        guard let cards: [Card] = SheetRealmAPI.getSectionCards(
            eikenGrade: selectedGrade,
            bookCategory: selectedBookCategory,
            bookConfig: selectedBookConfig,
            sectionTitle: selectedSectionTitle
        ) else { return false }
        
        let cardsContainer = CardsContainer(cards: cards, bookCategory: selectedBookCategory)
        
        /// 「学習を最後まで進めてから save しようとしているか」を判断
        let isFinished = (learnedCardsCount == self.cards.count)
        
        if !isFinished {
            pathHandler.backToPreviousScreen(count: 2)
            pathHandler.transitionScreen(to: .learnSelect(cardsContainer))
        } else {
            pathHandler.transitionScreen(to: .learnResult(cardsContainer, learnedCardCount))
        }
        
        return true
    }
}
