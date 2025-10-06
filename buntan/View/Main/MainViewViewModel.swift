import SwiftUI

@MainActor
@Observable
class MainViewViewModel {
    var selectedViewName: MainViewName = .logo
    var bookViewNavigator = BookNavigator()
    var checkViewNavigator = CheckNavigator()
}
