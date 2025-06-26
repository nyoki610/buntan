import SwiftUI


struct BookSelectView: ResponsiveView, SelectViewProtocol {
    

    /// conformance to ResponsiveView
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @StateObject var viewModel: BookSelectViewViewModel
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var bookUserInput: BookUserInput
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler,
        bookUserInput: BookUserInput,
        userDefaultHandler: LearnUserDefaultHandler,
        cards: [Card],
        options: [[Option]]
    ) {
        self.pathHandler = pathHandler
        self.bookUserInput = bookUserInput
        self.userDefaultHandler = userDefaultHandler
        self._viewModel = StateObject(
            wrappedValue: BookSelectViewViewModel(
                cards: cards,
                options: options,
                shouldShuffle: userDefaultHandler.shouldShuffle
            )
        )
    }
    
    var body: some View {
        
        swipeView(viewType: .book)
    }
    
    internal var settingButtons: some View {
        BookLearnSettingButtons(
            userDefaultHandler: userDefaultHandler,
            learnMode: .select,
            showSetting: $viewModel.showSetting) {
                viewModel.resetLearning(shouldShuffle: userDefaultHandler.shouldShuffle)
            }
    }
    
    internal func xmarkAction() {
        saveAction()
    }
    
    internal func saveAction() {
        viewModel.bookLearnSaveAction(
            pathHandler: pathHandler,
            loadingSharedData: loadingSharedData,
            bookUserInput: bookUserInput
        )
    }
}
