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
    
    func viewName(isBookView: Bool) -> ViewName {
        switch self {
        case .swipe: return isBookView ? .book(.swipe) : .check(.checkSwipe)
        case .select: return isBookView ? .book(.select) : .check(.checkSelect)
        case .type: return isBookView ? .book(.type) : .check(.checkType)
        }
    }
}
