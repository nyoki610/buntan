import Foundation

enum BookType {
    case freq
    case pos
    
    var headerTitle: String {
        switch self {
        case .freq: return "頻出度順に学習"
        case .pos: return "品詞別に学習"
        }
    }
}
