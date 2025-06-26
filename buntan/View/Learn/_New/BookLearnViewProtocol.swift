import SwiftUI


protocol BookLearnViewProtocol {
    
    associatedtype ViewModel: BookLearnProtocol
    var viewModel: ViewModel { get }
    var loadingSharedData: LoadingSharedData { get }
    var pathHandler: PathHandler { get }
    var bookUserInput: BookUserInput { get }
    var userDefaultHandler: LearnUserDefaultHandler { get }
}


extension BookLearnViewProtocol {
    
    func learnHeader(geometry: GeometryProxy) -> some View {
        
        _LearnHeader(
            viewModel: viewModel,
            geometry: geometry
        ) {
            saveAction()
        }
    }
    
    func learnSettingButtons(
        learnMode: LearnMode,
        showSetting: Binding<Bool>
    ) -> some View {
        
        BookLearnSettingButtons(
            userDefaultHandler: userDefaultHandler,
            learnMode: learnMode,
            showSetting: showSetting
        ) {
            viewModel.resetLearning(shouldShuffle: userDefaultHandler.shouldShuffle)
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
            bookUserInput: bookUserInput
        )
    }
}
