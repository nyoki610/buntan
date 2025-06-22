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

    func viewForName(pathHandler: PathHandler) -> some View {

        switch self {
        case .book:
            return AnyView(BookView(pathHandler: pathHandler))

        case .bookList(let bookList):
            return AnyView(BookListView(pathHandler: pathHandler, bookList: bookList))
        
        case .sectionList(let book):
            return AnyView(SectionListView(pathHandler: pathHandler, book: book))
        
        case .learnSelect(let cardsContainer):
            return AnyView(LearnSelectView(pathHandler: pathHandler, cardsContainer: cardsContainer))
        
        case .wordList(let cards):
            return AnyView(WordListView(pathHandler: pathHandler, cards: cards))
        
        case .swipe:
            return AnyView(SwipeView(pathHandler: pathHandler))
        
        case .select:
            return AnyView(SelectView(pathHandler: pathHandler, isBookView: true))
        
        case .type:
            return AnyView(TypeView(pathHandler: pathHandler))
        
        case .learnResult(let cardsContainer):
            return AnyView(LearnResultView(pathHandler: pathHandler, cardsContainer: cardsContainer))
        }
    }
}

