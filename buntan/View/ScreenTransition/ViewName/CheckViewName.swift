import SwiftUI


enum CheckViewName {
    
//    case checkSwipe([Card], [[Option]])
    case checkSelect([Card], [[Option]])
//    case checkType([Card], [[Option]])
    case checkResult([Card], [Int], Int)
}


extension CheckViewName: Equatable {
    static func == (lhs: CheckViewName, rhs: CheckViewName) -> Bool {
        switch (lhs, rhs) {
        case (.checkSelect, .checkSelect),
            (.checkResult, .checkResult):
//            (.checkSwipe, .checkSwipe),
//            (.checkType, .checkType),
            return true
        default:
            return false
        }
    }
}


extension CheckViewName: ViewNameProtocol {

    var screenName: String {
        switch self {

//        case .checkSwipe: return "checkSwipe"
        case .checkSelect: return "checkSelect"
//        case .checkType: return "checkType"
        case .checkResult: return "checkResult"
        }
    }
    
    var screenClassName: String {
        switch self {
//        case .checkSwipe: return "CheckSwipeView"
        case .checkSelect: return "CheckSelectView"
//        case .checkType: return "CheckTypeView"
        case .checkResult: return "CheckResultView"
        }
    }
    
    func viewForName(pathHandler: CheckViewPathHandler, userInput: CheckUserInput) -> some View {
        
        switch self {
//        case .checkSwipe(_, _):
//            return AnyView(EmptyView())
        
        case .checkSelect(let cards, let options):
            return AnyView(
                CheckSelectView(
                    pathHandler: pathHandler,
                    checkUserInput: userInput,
                    cards: cards,
                    options: options
                )
            )
            
//        case .checkType(_, _):
//            return AnyView(EmptyView())
        
        case .checkResult(let cards, let correctIndexList, let estimatedScore):
            return AnyView(
                CheckResultView(
                    pathHandler: pathHandler,
                    userInput: userInput,
                    cards: cards,
                    correctIndexList: correctIndexList,
                    estimatedScore: estimatedScore
                )
            )
        }
    }
}
