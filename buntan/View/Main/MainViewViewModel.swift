import SwiftUI

@MainActor
@Observable
class MainViewViewModel {
    
    /// tabView を管理
    var selectedViewName: MainViewName = .logo

    var bookViewNavigator = BookNavigator()
    var checkViewNavigator = CheckNavigator()
    
    /// BookView() or CheckView or RecordView() 表示時のみtabViewを表示
    ///     - BookView() -> bookSharedData.path が空かどうかを監視
    ///     - CheckView() -> checkSharedData.path が空かどうかを監視
    ///     - RecordView() -> 常に tabView を表示
    var showTabView: Bool = true
    
    func updateShowTabView() {
        showTabView = bookViewNavigator.path.count + checkViewNavigator.path.count == 0
    }
}
