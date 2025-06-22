import SwiftUI
import FirebaseAnalytics


class PathHandler: ObservableObject {
    
    /// contoroller for navigationPath
    /// cannot be accessed directly
    @Published private var path: [ViewName] = []

    /// Binding for NavigationStack
    /// can be accessed directly
    public var navigationPath: Binding<[ViewName]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    func transitionScreen(to viewName: ViewName) {
        path.append(viewName)
        AnalyticsHandler.logScreenTransition(viewName: viewName)
    }
    
    func backToPreviousScreen(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    
    func backToRootScreen() {
        path.removeAll()
    }
    
    var isEmpty: Bool {
        path.isEmpty
    }
}
