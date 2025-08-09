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
        LearnBottomButtons(
            viewModel: viewModel,
            shouldReadOut: userDefaultHandler.shouldReadOut
        ) {
            saveAction()
        }
    }
    
    func saveAction() {
        viewModel.bookLearnSaveAction(
            navigator: navigator,
            loadingSharedData: loadingSharedData,
            bookUserInput: userInput,
            learnedCardsCount: viewModel.cards.count
        )
    }
    
    func xmarkButtonAction() {
        
        /// １単語も学習していない場合は save せずに exit
        guard viewModel.learnedCardsCount != 0 else {
            guard let cardsContainer = CardsContainer(userInput: userInput) else { return }
            navigator.pop(to: .sectionList(EmptyModel.book))
            navigator.push(.learnSelect(cardsContainer))
            return
        }
        saveAction()
    }
}
