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
                        bookViewPathHandler: viewModel.bookViewPathHandler,
                        checkViewPathHandler: viewModel.checkViewPathHandler
                    )
                    
                    if viewModel.showTabView {
                        tabView
                    }
                }
            }

            /// loadingView  を表示
            if loadingSharedData.isLoading {
                Background()
                loadingSharedData.loadingView()
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
        .onReceive(viewModel.bookViewPathHandler.$path) { _ in
            DispatchQueue.main.async {
                viewModel.updateShowTabView()
            }
        }
        .onReceive(viewModel.checkViewPathHandler.$path) { _ in
            DispatchQueue.main.async {
                viewModel.updateShowTabView()
            }
        }
    }
}
