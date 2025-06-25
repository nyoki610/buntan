import Foundation


extension BookLearnViewProtocol {
    
    func saveAction(pathHandler: PathHandler) {
        
        /// Keyboard を非表示 (for TypeView())
        learnManager.isKeyboardActive = false
        
        let cardsCount = learnManager.leftCardsIndexList.count + learnManager.rightCardsIndexList.count
        
        /// １単語も学習していない場合は save せずに exit
        guard cardsCount != 0 else {
            pathHandler.backToPreviousScreen(count: 1)
            return
        }
        
        guard let bookUserInput = userInput as? BookUserInput else { return }

        /// loading を開始
        loadingSharedData.startLoading(.save)

        /// ensure loading screen rendering by delaying the next process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard let selectedGrade = bookUserInput.selectedGrade,
                  let selectedBookCategory = bookUserInput.selectedBookCategory,
                  let selectedBookConfig = bookUserInput.selectedBookConfig,
                  let selectedSectionTitle = bookUserInput.selectedSectionTitle else { return }
            
            /// 学習内容を realm に保存
            guard SheetRealmAPI._updateCardsStatus(
                learnManager: learnManager,
                eikenGrade: selectedGrade,
                bookCategory: selectedBookCategory
            ) else { return }
            
            /// 学習量の記録を保存
            let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                          cardsCount)
            let _ = LearnRecordRealmAPI.uploadLearnRecord(learnRecord: learnRecord)
            
            guard let cards: [Card] = SheetRealmAPI.getSectionCards(
                eikenGrade: selectedGrade,
                bookCategory: selectedBookCategory,
                bookConfig: selectedBookConfig,
                sectionTitle: selectedSectionTitle
            ) else { return }

            /// loading を終了して画面遷移
            loadingSharedData.finishLoading {
                
                let cardsContainer = CardsContainer(cards: cards, bookCategory: selectedBookCategory)
                
                /// 「学習を最後まで進めてから save しようとしているか」を判断
                let isFinished = (cardsCount == learnManager.cards.count)
                
                if !isFinished {
                    pathHandler.backToPreviousScreen(count: 2)
                    pathHandler.transitionScreen(to: .book(.learnSelect(cardsContainer)))
                } else {
                    pathHandler.transitionScreen(to: .book(.learnResult(cardsContainer)))
                }
            }
        }
    }
}
