import SwiftUI
import FirebaseAnalytics


final class BookViewPathHandler: PathHandlerProtocol {
    @Published var path: [BookViewName] = []
}


final class CheckViewPathHandler: PathHandlerProtocol {
    @Published var path: [CheckViewName] = []
}


protocol PathHandlerProtocol: ObservableObject, AnyObject {
    
    associatedtype ViewNameType: ViewNameProtocol
    var path: [ViewNameType] { get set }
}

extension PathHandlerProtocol {
    
    func transitionScreen(to viewName: ViewNameType) {
        path.append(viewName)
        AnalyticsHandler.logScreenTransition(viewName: viewName)
    }
    
    func backToPreviousScreen(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    
    func backToDesignatedScreen(to viewName: ViewNameType) {
        
        guard let index = path.firstIndex(of: viewName) else { return }
        
        let removeCount = path.count - index - 1
        if removeCount > 0 {
            path.removeLast(removeCount)
        }
    }
    
    func backToRootScreen() {
        path.removeAll()
    }
}
