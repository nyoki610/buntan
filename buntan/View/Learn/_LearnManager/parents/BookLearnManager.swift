import SwiftUI


class BookLearnManager: _LearnManager {
    
    private let nonShuffledCards: [Card]
    private let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool) {
        
        let indices = Array(0..<cards.count).shuffled()

        let cards = shouldShuffle ? indices.map { cards[$0] } : cards
        let options = shouldShuffle ? indices.map { options[$0] } : options
        
        self.init(cards: cards, options: options, nonShuffledCards: cards, nonShuffledOptions: options)
    }
    
    init(cards: [Card], options: [[Option]], nonShuffledCards: [Card], nonShuffledOptions: [[Option]]) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        super.init(cards: cards, options: options)
    }
    
    func resetLearning(shouldShuffle: Bool) {
        
        topCardIndex = 0
        animationController = 0
        rightCardsIndexList = []
        leftCardsIndexList = []
        
        if shouldShuffle {
            let shuffledArrays = getShuffledArrays()
            cards = shuffledArrays.cards
            options = shuffledArrays.options
        } else {
            cards = nonShuffledCards
            options = nonShuffledOptions
        }
    }
    
    private func getShuffledArrays() -> (cards: [Card], options: [[Option]]) {
        
        let indices = Array(0..<nonShuffledCards.count).shuffled()
        
        let shuffledCards = indices.map { nonShuffledCards[$0] }
        let shuffledOptions = indices.map { nonShuffledOptions[$0] }
        
        return (shuffledCards, shuffledOptions)
    }
    
    /// 一つ前のカードに戻る処理
    func backButtonAction() -> Void {
        
        guard topCardIndex > 0 else { return }
        
        withAnimation(.easeOut(duration: 0.4)) {
            self.topCardIndex -= 1
        }
        self.animationController -= 1
        
        if self.rightCardsIndexList.contains(self.topCardIndex) {
            self.rightCardsIndexList.removeLast()
        }
        if self.leftCardsIndexList.contains(self.topCardIndex) {
            self.leftCardsIndexList.removeLast()
        }
    }
}

extension BookLearnManager {
    
    func shuffleAction(
        userDefaultHandler: LearnUserDefaultHandler,
        alertSharedData: AlertSharedData
    ) -> Void {
        
        if rightCardsIndexList.count + leftCardsIndexList.count == 0 {
            
            executeShuffle(userDefaultHandler: userDefaultHandler)
        } else {
            showShuffleAlert(userDefaultHandler: userDefaultHandler,
                             alertSharedData: alertSharedData) {
                self.executeShuffle(userDefaultHandler: userDefaultHandler)
            }
        }
    }
    
    private func showShuffleAlert(
        userDefaultHandler: LearnUserDefaultHandler,
        alertSharedData: AlertSharedData,
        executeShuffle: @escaping () -> Void
    ) -> Void {
        
        var title = "現在の進捗はリセットされます\n"
        title += userDefaultHandler.shouldShuffle ? "元に戻" : "シャッフル"
        title += "しますか？"
        
        let secondaryButtonLabel = userDefaultHandler.shouldShuffle ? "元に戻す" : "シャッフル"
        
        alertSharedData.showSelectiveAlert(
            title: title,
            message: "",
            secondaryButtonLabel: secondaryButtonLabel,
            secondaryButtonType: .defaultButton
        ) {
            executeShuffle()
        }
    }
    
    private func executeShuffle(userDefaultHandler: LearnUserDefaultHandler) {
        
        userDefaultHandler.shouldShuffle.toggle()
        resetLearning(shouldShuffle: userDefaultHandler.shouldShuffle)
    }
}


extension BookLearnManager {
    
    func bookSaveAction(
        pathHandler: PathHandler,
        loadingSharedData: LoadingSharedData,
        userInput: BookUserInput
    ) {
        
        /// Keyboard を非表示 (for TypeView())
        if let typLearnManager = self as? TypeLearnManager {
            typLearnManager.isKeyboardActive = false
        }
        
        guard checkLearnedCardExist(pathHandler: pathHandler) else { return }
        
        /// loading を開始
        loadingSharedData.startLoading(.save)

        /// ensure loading screen rendering by delaying the next process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            guard self.updateCardsStatus(userInput: userInput) else { return }
            
            guard self.uploadLearnRecord() else { return }
            
            /// loading を終了して画面遷移
            loadingSharedData.finishLoading {
                guard self.tnrasitionScreen(userInput: userInput, pathHandler: pathHandler) else { return }
            }
        }
    }
    
    private func learnedCardsCount() -> Int {
        self.leftCardsIndexList.count + self.rightCardsIndexList.count
    }
    
    private func checkLearnedCardExist(pathHandler: PathHandler) -> Bool {
                
        /// １単語も学習していない場合は save せずに exit
        guard learnedCardsCount() != 0 else {
            pathHandler.backToPreviousScreen(count: 1)
            return false
        }
        
        return true
    }
    
    private func updateCardsStatus(userInput: BookUserInput) -> Bool {

        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory else { return false }
        
        /// 学習内容を realm に保存
        guard SheetRealmAPI._updateCardsStatus(
            learnManager: self,
            eikenGrade: selectedGrade,
            bookCategory: selectedBookCategory
        ) else { return false }
        
        return true
    }
    
    private func uploadLearnRecord() -> Bool {
        
        /// 学習量の記録を保存
        let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                      learnedCardsCount())
        
        guard LearnRecordRealmAPI.uploadLearnRecord(learnRecord: learnRecord) else { return false }
        
        return true
    }
    
    private func tnrasitionScreen(
        userInput: BookUserInput,
        pathHandler: PathHandler
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
        let isFinished = (learnedCardsCount() == self.cards.count)
        
        if !isFinished {
            pathHandler.backToPreviousScreen(count: 2)
            pathHandler.transitionScreen(to: .book(.learnSelect(cardsContainer)))
        } else {
            pathHandler.transitionScreen(to: .book(.learnResult(cardsContainer)))
        }
        
        return true
    }
}
