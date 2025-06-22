import SwiftUI
import FirebaseAnalytics

/// 画面遷移を管理する enum
enum ViewName: Hashable {
    
    /// Logo
    case logo
    
    /// Book
    case book(BookViewName)
    
    /// Check
    case check(CheckViewName)

    /// Record
    case record


    var screenName: String {
        switch self {
        case .logo: return "logo"
        case .book(let bookViewName): return bookViewName.screenName
        case .check(let checkViewName): return checkViewName.screenName
        case .record: return "record"
        }
    }
    

    var screenClassName: String {
        switch self {
        case .logo: return "LogoView"
        case .book(let bookViewName): return bookViewName.screenClassName
        case .check(let checkViewName): return checkViewName.screenClassName
        case .record: return "RecordView"
        }
    }
    
    func viewForName(pathHandler: PathHandler) -> some View {

        switch self {
        case .logo:
            return AnyView(EmptyView())
        
        case .book(let bookViewName):
            return AnyView(bookViewName.viewForName(pathHandler: pathHandler))
        
        case .check(let checkViewName):
            return AnyView(checkViewName.viewForName(pathHandler: pathHandler))
        
        case .record:
            return AnyView(RecordView())
        }
    }
}

