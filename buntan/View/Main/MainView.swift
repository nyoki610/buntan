import SwiftUI

struct MainView: View {

    /// ObservedObjects
    @ObservedObject private var loadingManager = LoadingManager()
    @ObservedObject private var alertManager = AlertManager()
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        
        ZStack {
            
            switch viewModel.selectedViewName {
                
            case .logo:
                LogoView(
                    viewModel: LogoViewViewModel(
                        loadingManager: loadingManager,
                        alertManager: alertManager,
                        parentStateBinding: $viewModel.selectedViewName
                    )
                )
            
            case .forcedUpdate:
                ForcedUpdateView()

            case .root:
                
                TabView {
                    
                    BookView(
                        viewModel: BookViewViewModel(
                            navigator: viewModel.bookViewNavigator,
                            userInput: BookUserInput()
                        )
                    )
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("単語帳")
                    }
                    
                    CheckView(navigator: viewModel.checkViewNavigator)
                        .tabItem {
                            Image(systemName: "checklist.checked")
                            Text("テスト")
                        }
                    
                    RecordView()
                        .tabItem {
                            Image(systemName: "shoeprints.fill")
                            Text("記録")
                        }
                    
                    ContactView()
                        .tabItem {
                            Image(systemName: "paperplane.fill")
                            Text("お問い合わせ")
                        }
                }
                .tint(Orange.defaultOrange)
            }

            if let loadingStatus = loadingManager.loadingStatus {
                Background()
                LoadingView(status: loadingStatus)
            }
        }
        .environmentObject(loadingManager)
        .environmentObject(alertManager)
        .alert(item: $alertManager.alertType) { _ in
            alertManager.createAlert()
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
