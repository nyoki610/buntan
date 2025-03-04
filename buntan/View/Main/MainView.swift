import SwiftUI

struct MainView: ResponsiveView {
    
    /// This comment is added for git test
    /// plase delete this comment later
    
    @Environment(\.deviceType) var deviceType
    
    @ObservedObject private var loadingSharedData = LoadingSharedData()
    @ObservedObject private var alertSharedData = AlertSharedData()
    @ObservedObject private var realmService = RealmService()
    @ObservedObject var bookSharedData = BookSharedData()
    
    @ObservedObject var checkSharedData = CheckSharedData()
    @ObservedObject private var learnManager = LearnManager()
    
    @State private var showLogoView: Bool = true
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
            
            // if loadingSharedData.animationController || loadingSharedData.isLoading {
            if loadingSharedData.isLoading {
                
                Background()
            }
            
            if loadingSharedData.isLoading {
                
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
            guard let updatedBooksList = realmService.setupBooksList() else { return }
            bookSharedData.setupBooksList(updatedBooksList)
            checkSharedData.booksList = updatedBooksList
            
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
