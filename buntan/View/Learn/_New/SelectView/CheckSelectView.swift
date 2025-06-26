import SwiftUI


struct CheckSelectView: ResponsiveView, SelectViewProtocol {
    

    /// conformance to ResponsiveView
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @StateObject var viewModel: CheckSelectViewViewModel
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var checkUserInput: CheckUserInput
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler,
        checkUserInput: CheckUserInput,
        userDefaultHandler: LearnUserDefaultHandler,
        cards: [Card],
        options: [[Option]]
    ) {

        self.pathHandler = pathHandler
        self.checkUserInput = checkUserInput
        self.userDefaultHandler = userDefaultHandler
        self._viewModel = StateObject(
            wrappedValue: CheckSelectViewViewModel(
                cards: cards,
                options: options
            )
        )
    }
    
    var body: some View {
        
        swipeView(viewType: .check)
    }
    
    internal var settingButtons: some View {
        CheckLearnSettingButtons(
            userDefaultHandler: userDefaultHandler,
            showSetting: $viewModel.showSetting
        )
    }
    
    internal func xmarkAction() {
        saveAction()
    }
    
    internal func saveAction() {
        viewModel.checkLearnSaveAction(
            pathHandler: pathHandler,
            loadingSharedData: loadingSharedData,
            checkUserInput: checkUserInput
        )
    }
}
