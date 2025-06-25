//import Foundation
//
//
//extension BookLearnViewProtocol {
//    
//    internal func bookSaveAction() {
//        
//        /// Keyboard を非表示 (for TypeView())
//        if let typLearnManager = learnManager as? TypeLearnManager {
//            typLearnManager.isKeyboardActive = false
//        }
//        
//        guard checkLearnedCardExist(pathHandler: pathHandler) else { return }
//        
//        /// loading を開始
//        loadingSharedData.startLoading(.save)
//
//        /// ensure loading screen rendering by delaying the next process
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            
//            guard updateCardsStatus() else { return }
//            
//            guard uploadLearnRecord() else { return }
//            
//            /// loading を終了して画面遷移
//            loadingSharedData.finishLoading {
//                guard tnrasitionScreen(pathHandler: pathHandler) else { return }
//            }
//        }
//    }
//    
//    private func learnedCardsCount() -> Int {
//        learnManager.leftCardsIndexList.count + learnManager.rightCardsIndexList.count
//    }
//    
//    private func checkLearnedCardExist(pathHandler: PathHandler) -> Bool {
//                
//        /// １単語も学習していない場合は save せずに exit
//        guard learnedCardsCount() != 0 else {
//            pathHandler.backToPreviousScreen(count: 1)
//            return false
//        }
//        
//        return true
//    }
//    
//    private func updateCardsStatus() -> Bool {
//        
//        guard let bookUserInput = userInput as? BookUserInput else { return  false }
//        
//        guard let selectedGrade = bookUserInput.selectedGrade,
//              let selectedBookCategory = bookUserInput.selectedBookCategory else { return false }
//        
//        /// 学習内容を realm に保存
//        guard SheetRealmAPI._updateCardsStatus(
//            learnManager: learnManager,
//            eikenGrade: selectedGrade,
//            bookCategory: selectedBookCategory
//        ) else { return false }
//        
//        return true
//    }
//    
//    private func uploadLearnRecord() -> Bool {
//        
//        /// 学習量の記録を保存
//        let learnRecord = LearnRecord(UUID().uuidString, Date(),
//                                      learnedCardsCount())
//        
//        guard LearnRecordRealmAPI.uploadLearnRecord(learnRecord: learnRecord) else { return false }
//        
//        return true
//    }
//    
//    private func tnrasitionScreen(pathHandler: PathHandler) -> Bool {
//        
//        guard let bookUserInput = userInput as? BookUserInput else { return  false }
//        
//        guard let selectedGrade = bookUserInput.selectedGrade,
//              let selectedBookCategory = bookUserInput.selectedBookCategory,
//              let selectedBookConfig = bookUserInput.selectedBookConfig,
//              let selectedSectionTitle = bookUserInput.selectedSectionTitle else { return false }
//        
//        guard let cards: [Card] = SheetRealmAPI.getSectionCards(
//            eikenGrade: selectedGrade,
//            bookCategory: selectedBookCategory,
//            bookConfig: selectedBookConfig,
//            sectionTitle: selectedSectionTitle
//        ) else { return false }
//        
//        let cardsContainer = CardsContainer(cards: cards, bookCategory: selectedBookCategory)
//        
//        /// 「学習を最後まで進めてから save しようとしているか」を判断
//        let isFinished = (learnedCardsCount() == learnManager.cards.count)
//        
//        if !isFinished {
//            pathHandler.backToPreviousScreen(count: 2)
//            pathHandler.transitionScreen(to: .book(.learnSelect(cardsContainer)))
//        } else {
//            pathHandler.transitionScreen(to: .book(.learnResult(cardsContainer)))
//        }
//        
//        return true
//    }
//}
