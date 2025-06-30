import SwiftUI


protocol _LearnViewProtocol: ResponsiveView {
    
    associatedtype ViewModelType: BaseLearnViewViewModel
    var viewModel: ViewModelType { get }
    
    associatedtype UserInputType: UserInput
    var userInput: UserInputType { get }
    
    associatedtype PathHandlerType: PathHandlerProtocol
    var pathHandler: PathHandlerType { get }
    
    var loadingSharedData: LoadingSharedData { get }
    
    var userDefaultHandler: LearnUserDefaultHandler { get }
    
    func xmarkButtonAction() -> Void
    func saveAction() -> Void
}


extension _LearnViewProtocol {
    
    func learnHeader(geometry: GeometryProxy) -> some View {
        
        LearnHeader(
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
