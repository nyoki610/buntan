import SwiftUI

@MainActor
protocol Navigating: ObservableObject, AnyObject {
    
    associatedtype ViewNameType: ViewNameProtocol
    var path: [ViewNameType] { get set }
    func push(_ viewName: ViewNameType)
    func pop(count: Int)
    func pop(to viewName: ViewNameType)
    func popToRoot()
}

extension Navigating {
    
    func push(_ viewName: ViewNameType) {
        path.append(viewName)
        AnalyticsLogger.logScreenTransition(viewName: viewName)
    }
    
    func pop(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    
    func pop(to viewName: ViewNameType) {
        
        guard let index = path.firstIndex(of: viewName) else { return }
        
        let removeCount = path.count - index - 1
        if removeCount > 0 {
            path.removeLast(removeCount)
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
