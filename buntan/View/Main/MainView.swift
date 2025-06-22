import SwiftUI

struct MainView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    
    /// ObservedObjects
    @ObservedObject private var loadingSharedData = LoadingSharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    
    @ObservedObject private var realmService = RealmService()
    @ObservedObject private var learnManager = LearnManager()
    
    /// 起動時の LogoView の表示を管理
    @State private var showLogoView: Bool = true
    
    /// tabView を管理
    @State var selectedRootViewName: RootViewName = .book
    
    @StateObject var bookViewPathHandler = PathHandler()
    @StateObject var checkViewPathHandler = PathHandler()
    
    var body: some View {
        
        ZStack {
            
            if showLogoView {
                logoView
            } else {
                ZStack {
                    selectedRootViewName.viewForName(
                        bookViewPathHandler: bookViewPathHandler,
                        checkViewPathHandler: checkViewPathHandler
                    )
                    
                    tabView
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
        .environmentObject(realmService)
        .environmentObject(learnManager)
        .alert(item: $alertSharedData.alertType) { _ in
            alertSharedData.createAlert()
        }
        .onAppear {
            /// bookSharedata.bookList を初期化
//            guard let updatedBooksDict = realmService.booksDict else { return }
//            realmService.booksDict = updatedBooksDict
//            let updatedBooksDict = realmService.booksDict
//            checkSharedData.booksDict = updatedBooksDict
            
            /// LogoView を 3 秒間表示した後, 画面遷移
            Task {
                do {
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    withAnimation {
                        showLogoView = false
                    }
                } catch { print("Error: \(error)") }
            }
        }
    }
}
