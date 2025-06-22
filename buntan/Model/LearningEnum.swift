import Foundation

/*
enum LearnType {
    case each
    case all
}
 */

enum LearnRange: Int, CaseIterable {
    case notLearned
    case learning
    case all
}

enum LearnMode: String, CaseIterable, Identifiable {
    case swipe, select, type
    
    var id: String {
        UUID().uuidString
    }
    
    func viewName(cards: [Card], isBookView: Bool) -> ViewName {
        switch self {
        case .swipe: return isBookView ? .book(.swipe(cards)) : .check(.checkSwipe(cards))
        case .select: return isBookView ? .book(.select(cards)) : .check(.checkSelect(cards))
        case .type: return isBookView ? .book(.type(cards)) : .check(.checkType(cards))
        }
    }
}
