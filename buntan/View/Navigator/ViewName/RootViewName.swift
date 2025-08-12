import SwiftUI


enum RootViewName {
    
    case book
    case check
    case record
}


extension RootViewName: Equatable {
    static func == (lhs: RootViewName, rhs: RootViewName) -> Bool {
        switch (lhs, rhs) {
        case (.book, .book),
             (.check, .check),
             (.record, .record):
            return true
        default:
            return false
        }
    }
}


extension RootViewName: ViewNameProtocol {
    
    var screenName: String {
        switch self {
        case .book: return "book"
        case .check: return "check"
        case .record: return "record"
        }
    }

    var screenClassName: String {
        switch self {
        case .book: return "BookView"
        case .check: return "CheckView"
        case .record: return "RecordView"
        }
    }

    func viewForName(
        bookViewNavigator: BookNavigator,
        checkViewNavigator: CheckNavigator
    ) -> some View {
        switch self {
        case .book:
            let userInput = BookUserInput()
            let viewModel = BookViewViewModel(navigator: bookViewNavigator, userInput: userInput)
            return AnyView(BookView(viewModel: viewModel))
        case .check:
            return AnyView(CheckView(navigator: checkViewNavigator))
        case .record:
            return AnyView(RecordView())
        }
    }
}
