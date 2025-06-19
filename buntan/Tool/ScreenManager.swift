import SwiftUI
import FirebaseAnalytics

/// 画面遷移を管理する enum
enum ViewName: String {
    
    /// Logo
    case logo
    
    /// Book
    case book
    case bookList
    case sectionList
    case learnSelect
    case wordList
    case swipe
    case select
    case type
    case learnResult
    
    
    /// Check
    case check
    case checkSwipe
    case checkType
    case checkSelect
    case checkResult


    /// Record
    case record

    var screenClassName: String {
        switch self {
        case .logo: return "LogoView"
        case .book: return "BookView"
        case .bookList: return "BookListView"
        case .sectionList: return "SectionListView"
        case .learnSelect: return "LearnSelectView"
        case .wordList: return "WordListView"
        case .swipe: return "SwipeView"
        case .select: return "SelectView"
        case .type: return "TypeView"
        case .learnResult: return "LearnResultView"
        case .check: return "CheckView"
        case .checkSwipe: return "CheckSwipeView"
        case .checkType: return "CheckTypeView"
        case .checkSelect: return "CheckSelectView"
        case .checkResult: return "CheckResultView"
        case .record: return "RecordView"
        }
    }

    func logScreenView() {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: self.rawValue,
            AnalyticsParameterScreenClass: self.screenClassName
        ])
    }
    
    func viewForName(_ viewName: ViewName) -> some View {

        logScreenView()
        
        switch viewName {
        // case .logo: return AnyView(LogoView())
        // case .book: return AnyView(BookView())
        case .bookList: return AnyView(BookListView())
        case .sectionList: return AnyView(SectionListView())
        case .learnSelect: return AnyView(LearnSelectView())
        case .wordList: return AnyView(WordListView())
        case .swipe: return AnyView(SwipeView())
        case .select: return AnyView(SelectView(isBookView: true))
        case .type: return AnyView(TypeView())
        case .learnResult: return AnyView(LearnResultView())
        
        // case .check: return AnyView(CheckView())
        case .checkSwipe: return AnyView(EmptyView())
        case .checkType: return AnyView(EmptyView())
        case .checkSelect: return AnyView(SelectView(isBookView: false))
        case .checkResult: return AnyView(CheckResultView())

        // case .record: return AnyView(RecordView())
        default: return AnyView(EmptyView())
        }
    }
}

