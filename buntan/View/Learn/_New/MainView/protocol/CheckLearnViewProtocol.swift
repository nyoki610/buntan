import SwiftUI


protocol CheckLearnViewProtocol: _LearnViewProtocol where
ViewModelType: CheckLearnProtocol,
UserInputType: CheckUserInput {
    var alertSharedData: AlertSharedData { get }
}


extension CheckLearnViewProtocol {
    
    func learnSettingButtons(
        showSetting: Binding<Bool>
    ) -> some View {
        
        CheckLearnSettingButtons(
            userDefaultHandler: userDefaultHandler,
            showSetting: showSetting
        )
    }
    
    func saveAction() {
        
        viewModel.checkLearnSaveAction(
            pathHandler: pathHandler,
            loadingSharedData: loadingSharedData,
            checkUserInput: userInput
        )
    }
    
    func xmarkButtonAction() {
        let isFInished = (viewModel.learnedCardsCount == viewModel.cards.count)
        
        guard isFInished else {
            alertSharedData.showSelectiveAlert(
                title: "テストを中断しますか？",
                message: "",
                secondaryButtonLabel: "終了",
                secondaryButtonType: .defaultButton
            ) {
                pathHandler.backToPreviousScreen(count: 1)
            }
            return
        }
        saveAction()
    }
}
