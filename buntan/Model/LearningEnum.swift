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
        case .swipe: return isBookView ? .swipe : .checkSwipe
        case .select: return isBookView ? .select : .checkSelect
        case .type: return isBookView ? .type : .checkType
        }
    }
    
    var jpName: String {
        switch self {
        case .swipe: "カード"
        case .select: "４択"
        case .type: "タイピング"
        }
    }
}
