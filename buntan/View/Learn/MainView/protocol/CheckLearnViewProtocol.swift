import SwiftUI


protocol CheckLearnViewProtocol: _LearnViewProtocol where
ViewModelType: CheckLearnViewViewModelProtocol,
UserInputType: CheckUserInput,
NavigatorType: CheckNavigator {
    var alertManager: AlertManager { get }
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
    
    func saveAction() async {
        
        await viewModel.checkLearnSaveAction(
            navigator: navigator,
            loadingManager: loadingManager,
            checkUserInput: userInput
        )
    }
    
    // TODO: refactor
    func xmarkButtonAction() async {
        let isFInished = (viewModel.learnedCardsCount == viewModel.cards.count)
        
        guard isFInished else {
            let config = AlertManager.SelectiveAlertConfig(
                title: "テストを中断しますか？",
                message: nil,
                secondaryButtonLabel: "終了",
                secondaryButtonType: .defaultButton) {
                    navigator.pop(count: 1)
                }
            await alertManager.showAlert(type: .selective(config: config))
            return
        }
        await saveAction()
    }
}
