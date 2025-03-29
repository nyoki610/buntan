import SwiftUI

struct MainView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    
    /// ObservedObjects
    @ObservedObject private var loadingSharedData = LoadingSharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    @ObservedObject private var realmService = RealmService()
    @ObservedObject private var learnManager = LearnManager()
    @ObservedObject var bookSharedData = BookSharedData()
    @ObservedObject var checkSharedData = CheckSharedData()
    
    /// 起動時の LogoView の表示を管理
    @State private var showLogoView: Bool = true
    
    /// tabView を管理
    @State var selectedTab: TabType = .book
    
    var body: some View {
        
        ZStack {
            
            if showLogoView {
                logoView
            } else {
                ZStack {
                    selectedTab.view
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
        .environmentObject(bookSharedData)
        .environmentObject(checkSharedData)
        .environmentObject(learnManager)
        .alert(item: $alertSharedData.alertType) { _ in
            alertSharedData.createAlert()
        }
        .onAppear {
            /// bookSharedata.bookList を初期化
            guard let updatedBooksList = realmService.setupBooksList() else { return }
            bookSharedData.setupBooksList(updatedBooksList)
            checkSharedData.booksList = updatedBooksList
            
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
