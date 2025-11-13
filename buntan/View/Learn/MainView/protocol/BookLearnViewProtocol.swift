import SwiftUI


protocol BookLearnViewProtocol: _LearnViewProtocol where
ViewModelType: BookLearnViewViewModelProtocol,
UserInputType: BookUserInput,
NavigatorType: BookNavigator {}


extension BookLearnViewProtocol {

    func learnSettingButtons(
        learnMode: LearnMode,
        showSetting: Binding<Bool>
    ) -> some View {
        
        BookLearnSettingButtons(
            userDefaultHandler: userDefaultHandler,
            learnMode: learnMode,
            showSetting: showSetting,
            isInitialState: viewModel.learnedCardsCount == 0
        ) {
            viewModel.shuffleAction(shouldShuffle: userDefaultHandler.shouldShuffle)
        }
    }
    
    var learnBottomButtons: some View {
        _LearnBottomButtons(
            viewModel: viewModel,
            shouldReadOut: userDefaultHandler.shouldReadOut
        ) {
            Task { await saveAction() }
        }
    }
    
    func saveAction() async {
        await viewModel.bookLearnSaveAction(
            navigator: navigator,
            loadingManager: loadingManager,
            bookUserInput: userInput,
            learnedCardsCount: viewModel.cards.count
        )
    }
    
    @MainActor
    func xmarkButtonAction() async {
        
        /// １単語も学習していない場合は save せずに exit
        guard viewModel.learnedCardsCount != 0 else {
            guard let cardsContainer = CardsContainer(userInput: userInput) else { return }
            navigator.pop(to: .sectionList)
            navigator.push(.learnSelect(cardsContainer))
            return
        }
        
        await saveAction()
    }
}
