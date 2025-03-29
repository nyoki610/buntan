import SwiftUI

enum ViewName {
    
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
    
    func viewForName(_ viewName: ViewName) -> some View {
        
        switch viewName {
            
        case .book: return AnyView(BookView())
        case .bookList: return AnyView(BookListView())
        case .sectionList: return AnyView(SectionListView())
        case .learnSelect: return AnyView(LearnSelectView())
        case .wordList: return AnyView(WordListView())
        case .swipe: return AnyView(SwipeView())
        case .select: return AnyView(SelectView(isBookView: true))
        case .type: return AnyView(TypeView())
        case .learnResult: return AnyView(LearnResultView())
        
        case .check: return AnyView(CheckView())
        case .checkSwipe: return AnyView(EmptyView())
        case .checkType: return AnyView(EmptyView())
        case .checkSelect: return AnyView(SelectView(isBookView: false))
        case .checkResult: return AnyView(CheckResultView())
        }
    }
}

