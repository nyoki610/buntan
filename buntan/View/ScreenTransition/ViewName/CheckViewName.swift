import SwiftUI


enum CheckViewName {
    
    case checkSwipe([Card])
    case checkType([Card])
    case checkSelect([Card])
    case checkResult
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
    
    func viewForName(pathHandler: PathHandler, userInput: CheckUserInput) -> some View {
        
        switch self {
        case .checkSwipe(_):
            return AnyView(EmptyView())
        
        case .checkType(_):
            return AnyView(EmptyView())
        
        case .checkSelect(let cards):
            return AnyView(
                SelectView(
                    pathHandler:pathHandler,
                    userInput: userInput,
                    cards: cards,
                    options: nil,
                    isBookView: false
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
