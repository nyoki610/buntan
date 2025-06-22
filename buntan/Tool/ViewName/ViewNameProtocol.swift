import SwiftUI
import FirebaseAnalytics

protocol ViewNameProtocol: Hashable {
    
    var screenName: String { get }
    var screenClassName: String { get }
    
    associatedtype AssociatedViewType: View
    func viewForName(path: Binding<[ViewName]>) -> AssociatedViewType
}
