import SwiftUI


class MainViewViewModel: ObservableObject {
    
    /// tabView を管理
    @Published var selectedRootViewName: RootViewName = .book

    @Published var bookViewPathHandler = BookViewPathHandler()
    @Published var checkViewPathHandler = CheckViewPathHandler()
    
    @Published var showLogoView: Bool = true
    
    /// BookView() or CheckView or RecordView() 表示時のみtabViewを表示
    ///     - BookView() -> bookSharedData.path が空かどうかを監視
    ///     - CheckView() -> checkSharedData.path が空かどうかを監視
    ///     - RecordView() -> 常に tabView を表示
    @Published var showTabView: Bool = true
    
    @Published var isFetchingLatestCards: Bool = false
    
    func updateShowTabView() {
        showTabView = bookViewPathHandler.path.count + checkViewPathHandler.path.count == 0
    }
    
    func onAppearAction() async {
        
        do {
            
            let latestVersionId = try await APIHandler.getLatestVersion()
            
            let userCardsVersionId = VersionUserDefaultHandler.getUsersCardsVersionId() ?? ""
            
            if latestVersionId == userCardsVersionId {
                await transitionScreen(withDelay: true)
            } else {
                
                DispatchQueue.main.async {
                    self.isFetchingLatestCards = true
                }
                
                guard await fetchLatestCards() else { return }
                VersionUserDefaultHandler.saveUsersCardsVersionId(version: latestVersionId)
                await transitionScreen(withDelay: false)
                
                DispatchQueue.main.async {
                    self.isFetchingLatestCards = false
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func fetchLatestCards() async -> Bool {
        
        do {
            let (firstGradeCards, preFirstGradeCards) = try await APIHandler.getLatestCards()
            let _ = SheetRealmAPI.updateSheetCards(grade: .first, newCards: firstGradeCards)
            let _ = SheetRealmAPI.updateSheetCards(grade: .preFirst, newCards: preFirstGradeCards)
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    private func transitionScreen(withDelay: Bool) async {
        
        if withDelay {
            do {
                try await Task.sleep(nanoseconds: 3_000_000_000)
            } catch {
                print("Error: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.showLogoView = false
            }
        }
    }
}
