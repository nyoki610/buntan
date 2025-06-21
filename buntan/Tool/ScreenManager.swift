import SwiftUI
import FirebaseAnalytics

/// 画面遷移を管理する enum
enum ViewName: Hashable {
    
    /// Logo
    case logo
    
    /// Book
    case book
    case bookList([Book])
    case sectionList(Book)
    case learnSelect(Section)
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


    var screenName: String {
        switch self {
        case .logo: return "logo"
        case .book: return "book"
        case .bookList: return "bookList"
        case .sectionList: return "sectionList"
        case .learnSelect: return "learnSelect"
        case .wordList: return "wordList"
        case .swipe: return "swipe"
        case .select: return "select"
        case .type: return "type"
        case .learnResult: return "learnResult"
        case .check: return "check"
        case .checkSwipe: return "checkSwipe"
        case .checkType: return "checkType"
        case .checkSelect: return "checkSelect"
        case .checkResult: return "checkResult"
        case .record: return "record"
        }
    }
    

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
            AnalyticsParameterScreenName: self.screenName,
            AnalyticsParameterScreenClass: self.screenClassName
        ])
    }
    
    func viewForName(_ viewName: ViewName) -> some View {

        logScreenView()
        
        switch viewName {
        // case .logo: return AnyView(LogoView())
        // case .book: return AnyView(BookView())
        case .bookList(let bookList): return AnyView(BookListView(bookList: bookList))
        case .sectionList(let book): return AnyView(SectionListView(book: book))
        case .learnSelect(let section): return AnyView(LearnSelectView(section: section))
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

