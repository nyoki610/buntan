import SwiftUI
import FirebaseAnalytics

/// 画面遷移を管理する enum
enum ViewName: Hashable {
    
    /// Logo
    case logo
    
    case root(RootViewName)
    
    /// Book
    case book(BookViewName)
    
    /// Check
    case check(CheckViewName)

    
    var screenName: String {
        switch self {
        case .logo: return "logo"
        case .root(let rootViewName): return rootViewName.screenName
        case .book(let bookViewName): return bookViewName.screenName
        case .check(let checkViewName): return checkViewName.screenName
        }
    }
    

    var screenClassName: String {
        switch self {
        case .logo: return "LogoView"
        case .root(let rootViewName): return rootViewName.screenClassName
        case .book(let bookViewName): return bookViewName.screenClassName
        case .check(let checkViewName): return checkViewName.screenClassName
        }
    }
}

