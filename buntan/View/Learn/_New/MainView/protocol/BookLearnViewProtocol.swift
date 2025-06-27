import SwiftUI


protocol BookLearnViewProtocol: _LearnViewProtocol where
ViewModelType: BookLearnProtocol,
UserInputType: BookUserInput {}


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
            pathHandler: pathHandler,
            loadingSharedData: loadingSharedData,
            bookUserInput: userInput,
            learnedCardsCount: viewModel.cards.count
        )
    }
    
    func xmarkButtonAction() {
        
        var isLearnedCardExist: Bool {
            viewModel.learnedCardsCount != 0
        }
        
        guard isLearnedCardExist else {
            pathHandler.backToPreviousScreen(count: 1)
            return
        }
        saveAction()
    }
    
    func shuffleAction() {
        
    }
}
