import SwiftUI


enum BookViewName {
    
    case bookList([Book])
    case sectionList
    case learnSelect(CardsContainer)
    case wordList([Card])
    case swipe([Card], [[Option]])
    case select([Card], [[Option]])
    case type([Card], [[Option]])
    case learnResult(CardsContainer, Int)
}


extension BookViewName: Equatable {
    static func == (lhs: BookViewName, rhs: BookViewName) -> Bool {
        switch (lhs, rhs) {
        case (.bookList, .bookList),
             (.sectionList, .sectionList),
             (.learnSelect, .learnSelect),
             (.wordList, .wordList),
             (.swipe, .swipe),
             (.select, .select),
             (.type, .type),
             (.learnResult, .learnResult):
            return true
        default:
            return false
        }
    }
}


extension BookViewName: ViewNameProtocol {
    
    var screenName: String {
        switch self {
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
        case .bookList: return "BookListView"
        case .sectionList: return "SectionListView"
        case .learnSelect: return "LearnSelectView"
        case .wordList: return "WordListView"
        case .swipe: return "SwipeView"
        case .select: return "SelectView"
        case .type: return "TypeView"
        case .learnResult: return "_LearnResultView"
        }
    }

    @MainActor
    func viewForName(navigator: BookNavigator, userInput: BookUserInput) -> some View {

        switch self {

        case .bookList(let books):
            return AnyView(
                BookListView(
                    viewModel: .init(
                        argument: .init(
                            navigator: navigator,
                            userInput: userInput
                        ),
                        books: books
                    )
                )
            )
        
        case .sectionList:
            return AnyView(
                SectionListView(
                    viewModel: .init(
                        argument: .init(
                            navigator: navigator,
                            userInput: userInput
                        )
                    )
                )
            )
        
        case .learnSelect(let cardsContainer):
            return AnyView(
                LearnSelectView(
                    navigator: navigator,
                    userInput: userInput,
                    cardsContainer: cardsContainer
                )
            )
        
        case .wordList(let cards):
            return AnyView(
                WordListView(
                    navigator: navigator,
                    cards: cards
                )
            )
        
        case .swipe(let cards, let options):
            return AnyView(
                BookSwipeView(
                    navigator: navigator,
                    bookUserInput: userInput,
                    cards: cards,
                    options: options
                )
            )

        case .select(let cards, let options):
            return AnyView(
                BookSelectView(
                    navigator: navigator,
                    bookUserInput: userInput,
                    cards: cards,
                    options: options)
            )
        
        case .type(let cards, let options):
            return AnyView(
                BookTypeView(
                    navigator: navigator,
                    bookUserInput: userInput,
                    cards: cards,
                    options: options
                )
            )
        
        case .learnResult(let cardsContainer, let learnedCardCount):
            return AnyView(
                LearnResultView(
                    navigator: navigator,
                    userInput: userInput,
                    cardsContainer: cardsContainer,
                    learnedCardCount: learnedCardCount
                )
            )
        }
    }
}
