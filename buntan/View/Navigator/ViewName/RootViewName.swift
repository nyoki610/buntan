import SwiftUI


enum MainViewName: Equatable, ViewNameProtocol {
    
    case logo
    case root(Root)
    
    enum Root: Equatable {
        
        case book
        case check
        case record
    }
    
    var screenName: String {
        switch self {
        case .logo: return "logo"
        case .root(let rootViewName): return rootViewName.screenName
        }
    }
    
    var screenClassName: String {
        switch self {
        case .logo: return "LogoView"
        case .root(let rootViewName): return rootViewName.screenClassName
        }
    }
}


extension MainViewName.Root: ViewNameProtocol {
    
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
