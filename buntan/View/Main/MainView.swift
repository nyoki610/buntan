import SwiftUI

struct MainView: View {

    /// ObservedObjects
    @ObservedObject private var loadingSharedData = LoadingSharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        ZStack {
            
            if viewModel.showLogoView {
                logoView
            } else {
                ZStack {
                    viewModel.selectedRootViewName.viewForName(
                        bookViewNavigator: viewModel.bookViewNavigator,
                        checkViewNavigator: viewModel.checkViewNavigator
                    )
                    
                    if viewModel.showTabView {
                        tabView
                    }
                }
            }

            if let status = loadingSharedData.loadingStatus {
                Background()
                LoadingView(status: status)
            }
        }
        .environmentObject(loadingSharedData)
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
