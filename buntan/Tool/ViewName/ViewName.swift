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


    private var screenName: String {
        switch self {
        case .logo: return "logo"
        case .book(let bookViewName): return bookViewName.screenName
        case .check(let checkViewName): return checkViewName.screenName
        case .record: return "record"
        }
    }
    

    private var screenClassName: String {
        switch self {
        case .logo: return "LogoView"
        case .book(let bookViewName): return bookViewName.screenClassName
        case .check(let checkViewName): return checkViewName.screenClassName
        case .record: return "RecordView"
        }
    }

    private func logScreenView() {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: self.screenName,
            AnalyticsParameterScreenClass: self.screenClassName
        ])
    }
    
    func viewForName(path: Binding<[ViewName]>) -> some View {

        logScreenView()
        
        switch self {
        case .logo:
            return AnyView(EmptyView())
        
        case .book(let bookViewName):
            return AnyView(bookViewName.viewForName(path: path))
        
        case .check(let checkViewName):
            return AnyView(checkViewName.viewForName(path: path))
        
        case .record:
            return AnyView(RecordView())
        }
    }
}

