//import SwiftUI
//import FirebaseAnalytics
//
//
//class _PathHandler: PathHandlerProtocol {
//    
//    /// contoroller for navigationPath
//    /// cannot be accessed directly
//    @Published internal var path: [ViewName] = []
//
//    /// Binding for NavigationStack
//    /// can be accessed directly
//    public var navigationPath: Binding<[ViewName]> {
//        Binding(
//            get: { self.path },
//            set: { self.path = $0 }
//        )
//    }
//
//    func transitionScreen(to viewName: ViewName) {
//        path.append(viewName)
////        AnalyticsHandler.logScreenTransition(viewName: viewName)
//    }
//    
//    func backToPreviousScreen(count: Int) {
//        guard path.count >= count else { return }
//        path.removeLast(count)
//    }
//    
//    func backToDesignatedScreen(to viewName: ViewName) {
//        
//        guard let index = path.firstIndex(of: viewName) else { return }
//        
//        let removeCount = path.count - index - 1
//        if removeCount > 0 {
//            path.removeLast(removeCount)
//        }
//    }
//    
//    func backToRootScreen() {
//        path.removeAll()
//    }
//    
//    var isEmpty: Bool {
//        path.isEmpty
//    }
//}
