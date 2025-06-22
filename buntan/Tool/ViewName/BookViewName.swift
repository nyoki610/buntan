import SwiftUI


enum BookViewName {
    
    case book
    case bookList([Book])
    case sectionList(Book)
    case learnSelect(CardsContainer)
    case wordList([Card])
    case swipe
    case select
    case type
    case learnResult(CardsContainer)
}

extension BookViewName: ViewNameProtocol {
    
    var screenName: String {
        switch self {
        case .book: return "book"
        case .bookList: return "bookList"
        case .sectionList: return "sectionList"
        case .learnSelect: return "learnSelect"
        case .wordList: return "wordList"
        case .swipe: return "swipe"
        case .select: return "select"
        case .type: return "type"
        case .learnResult: return "learnResult"
        }
    }
    

    var screenClassName: String {
        switch self {
        case .book: return "BookView"
        case .bookList: return "BookListView"
        case .sectionList: return "SectionListView"
        case .learnSelect: return "LearnSelectView"
        case .wordList: return "WordListView"
        case .swipe: return "SwipeView"
        case .select: return "SelectView"
        case .type: return "TypeView"
        case .learnResult: return "LearnResultView"
        }
    }

    func viewForName(path: Binding<[ViewName]>) -> some View {

        switch self {
        case .book:
            return AnyView(BookView(path: path))

        case .bookList(let bookList):
            return AnyView(BookListView(path: path, bookList: bookList))
        
        case .sectionList(let book):
            return AnyView(SectionListView(path: path, book: book))
        
        case .learnSelect(let cardsContainer):
            return AnyView(LearnSelectView(path: path, cardsContainer: cardsContainer))
        
        case .wordList(let cards):
            return AnyView(WordListView(path: path, cards: cards))
        
        case .swipe:
            return AnyView(SwipeView(path: path))
        
        case .select:
            return AnyView(SelectView(path: path, isBookView: true))
        
        case .type:
            return AnyView(TypeView(path: path))
        
        case .learnResult(let cardsContainer):
            return AnyView(LearnResultView(path: path, cardsContainer: cardsContainer))
        }
    }
}

