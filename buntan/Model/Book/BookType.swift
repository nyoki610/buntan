import Foundation

enum BookType {
    case freq
    case pos
    
    var buttonLabel: String {
        switch self {
        case .freq: return "でる順"
        case .pos: return "品詞別"
        }
    }
    
    var headerTitle: String { "\(buttonLabel)に学習" }
}
