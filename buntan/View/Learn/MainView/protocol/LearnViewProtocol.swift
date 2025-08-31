import SwiftUI


protocol _LearnViewProtocol: View {
    
    associatedtype ViewModelType: BaseLearnViewViewModel
    var viewModel: ViewModelType { get }
    
    associatedtype UserInputType: UserInput
    var userInput: UserInputType { get }
    
    associatedtype NavigatorType: Navigating
    var navigator: NavigatorType { get }
    
    var loadingManager: LoadingManager { get }
    
    var userDefaultHandler: LearnUserDefaultHandler { get }
    
    func xmarkButtonAction() async -> Void
    func saveAction() async -> Void
}


extension _LearnViewProtocol {
    
    func learnHeader(geometry: GeometryProxy) -> some View {
        
        LearnHeader(
            viewModel: viewModel,
            geometry: geometry
        ) {
            Task { await xmarkButtonAction() }
        }
    }
    
    var learnBottomButtons: some View {
        LearnBottomButtons(
            viewModel: viewModel,
            shouldReadOut: userDefaultHandler.shouldReadOut
        ) {
            Task { await saveAction() }
        }
    }
}
