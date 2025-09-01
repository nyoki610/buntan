import SwiftUI

struct MainView: View {

    /// ObservedObjects
    @ObservedObject private var loadingManager = LoadingManager()
    @ObservedObject private var alertSharedData = AlertSharedData()
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        ZStack {
            
            switch viewModel.selectedViewName {
                
            case .logo:
                LogoView(loadingManager: loadingManager, selectedViewName: $viewModel.selectedViewName)
                
            case .root(let rootViewName):
                ZStack {
                    rootViewName.viewForName(
                        bookViewNavigator: viewModel.bookViewNavigator,
                        checkViewNavigator: viewModel.checkViewNavigator
                    )
                    
                    if viewModel.showTabView {
                        tabView
                    }
                }
            }

            if let status = loadingManager.loadingStatus {
                Background()
                LoadingView(status: status)
            }
        }
        .environmentObject(loadingManager)
        .environmentObject(alertSharedData)
        .alert(item: $alertSharedData.alertType) { _ in
            alertSharedData.createAlert()
        }
        .onAppear {
            Task {
                await viewModel.onAppearAction()
            }
        }
        .onReceive(viewModel.bookViewNavigator.$path) { _ in
            DispatchQueue.main.async {
                viewModel.updateShowTabView()
            }
        }
        .onReceive(viewModel.checkViewNavigator.$path) { _ in
            DispatchQueue.main.async {
                viewModel.updateShowTabView()
            }
        }
    }
}
