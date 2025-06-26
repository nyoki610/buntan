import SwiftUI


struct BookSelectView: ResponsiveView, SelectViewProtocol, BookLearnViewProtocol {
    

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
        cards: [Card],
        options: [[Option]]
    ) {
        self.pathHandler = pathHandler
        self.bookUserInput = bookUserInput
        let userDefaultHandler = LearnUserDefaultHandler()
        self._viewModel = StateObject(
            wrappedValue: BookSelectViewViewModel(
                cards: cards,
                options: options,
                shouldShuffle: userDefaultHandler.shouldShuffle
            )
        )
        self.userDefaultHandler = userDefaultHandler
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
}
