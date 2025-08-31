import SwiftUI


protocol CheckLearnViewProtocol: _LearnViewProtocol where
ViewModelType: CheckLearnViewViewModelProtocol,
UserInputType: CheckUserInput,
NavigatorType: CheckNavigator {
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
    
    func saveAction() async {
        
        await viewModel.checkLearnSaveAction(
            navigator: navigator,
            loadingSharedData: loadingSharedData,
            checkUserInput: userInput
        )
    }
    
    func xmarkButtonAction() async {
        let isFInished = (viewModel.learnedCardsCount == viewModel.cards.count)
        
        guard isFInished else {
            alertSharedData.showSelectiveAlert(
                title: "テストを中断しますか？",
                message: "",
                secondaryButtonLabel: "終了",
                secondaryButtonType: .defaultButton
            ) {
                navigator.pop(count: 1)
            }
            return
        }
        await saveAction()
    }
}
