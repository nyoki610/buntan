import SwiftUI


enum CheckViewName {
    
    case checkSwipe([Card], [[Option]])
    case checkType([Card], [[Option]])
    case checkSelect([Card], [[Option]])
    case checkResult
}


extension CheckViewName: Equatable {
    static func == (lhs: CheckViewName, rhs: CheckViewName) -> Bool {
        switch (lhs, rhs) {
        case (.checkSwipe, .checkSwipe),
             (.checkType, .checkType),
             (.checkSelect, .checkSelect),
             (.checkResult, .checkResult):
            return true
        default:
            return false
        }
    }
}


extension CheckViewName: ViewNameProtocol {

    var screenName: String {
        switch self {

        case .checkSwipe: return "checkSwipe"
        case .checkType: return "checkType"
        case .checkSelect: return "checkSelect"
        case .checkResult: return "checkResult"
        }
    }
    
    var screenClassName: String {
        switch self {
        case .checkSwipe: return "CheckSwipeView"
        case .checkType: return "CheckTypeView"
        case .checkSelect: return "CheckSelectView"
        case .checkResult: return "CheckResultView"
        }
    }
    
    func viewForName(pathHandler: CheckViewPathHandler, userInput: CheckUserInput) -> some View {
        
        switch self {
        case .checkSwipe(_, _):
            return AnyView(EmptyView())
        
        case .checkType(_, _):
            return AnyView(EmptyView())
        
        case .checkSelect(let cards, let options):
            return AnyView(
                CheckSelectView(
                    pathHandler: pathHandler,
                    checkUserInput: userInput,
                    cards: cards,
                    options: options
                )
            )
        
        case .checkResult:
            return AnyView(
                CheckResultView(
                    pathHandler: pathHandler,
                    userInput: userInput
                )
            )
        }
    }
}
