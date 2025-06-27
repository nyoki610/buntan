import SwiftUI


protocol _LearnViewProtocol: ResponsiveView {
    
    associatedtype ViewModelType: BaseLearnViewModel
    var viewModel: ViewModelType { get }
    
    associatedtype UserInputType: UserInput
    var userInput: UserInputType { get }
    
    var loadingSharedData: LoadingSharedData { get }
    var pathHandler: PathHandler { get }
    var userDefaultHandler: LearnUserDefaultHandler { get }
    
    func xmarkButtonAction() -> Void
    func saveAction() -> Void
}


extension _LearnViewProtocol {
    
    func learnHeader(geometry: GeometryProxy) -> some View {
        
        _LearnHeader(
            viewModel: viewModel,
            geometry: geometry
        ) {
            xmarkButtonAction()
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
}
