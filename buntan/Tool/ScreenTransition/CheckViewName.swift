import SwiftUI


enum CheckViewName {
    
    case check
    case checkSwipe
    case checkType
    case checkSelect
    case checkResult
}


extension CheckViewName: ViewNameProtocol {

    var screenName: String {
        switch self {

        case .check: return "check"
        case .checkSwipe: return "checkSwipe"
        case .checkType: return "checkType"
        case .checkSelect: return "checkSelect"
        case .checkResult: return "checkResult"
        }
    }
    
    var screenClassName: String {
        switch self {
        case .check: return "CheckView"
        case .checkSwipe: return "CheckSwipeView"
        case .checkType: return "CheckTypeView"
        case .checkSelect: return "CheckSelectView"
        case .checkResult: return "CheckResultView"
        }
    }
    
    func viewForName(pathHandler: PathHandler) -> some View {
        
        switch self {
        case .check:
            return AnyView(CheckView(pathHandler: pathHandler))
        
        case .checkSwipe:
            return AnyView(EmptyView())
        
        case .checkType:
            return AnyView(EmptyView())
        
        case .checkSelect:
            return AnyView(SelectView(pathHandler: pathHandler, isBookView: false))
        
        case .checkResult:
            return AnyView(CheckResultView(pathHandler: pathHandler))
        }
    }
}
