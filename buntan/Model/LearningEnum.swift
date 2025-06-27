import Foundation

/*
enum LearnType {
    case each
    case all
}
 */

enum LearnViewViewType {
    case book, check
}

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
}


extension LearnMode {
    
    func bookViewName(cards: [Card], options: [[Option]]) -> BookViewName {
        
        switch self {
        case .swipe: return .swipe(cards, options)
        case .select: return .select(cards, options)
        case .type: return .type(cards, options)
        }
    }
    
    func checkViewName(cards: [Card], options: [[Option]]) -> CheckViewName {
        
        switch self {
        case .swipe: return .checkSwipe(cards, options)
        case .select: return .checkSelect(cards, options)
        case .type: return .checkType(cards, options)
        }
    }
}
