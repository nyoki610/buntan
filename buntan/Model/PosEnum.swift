import Foundation

enum Pos: Int, CaseIterable {
    
    case noun = 1
    case verb
    case adjective
    case adverb
    case idiom
    
    var jaLabel: String {
        switch self {
        case .noun: return "名"
        case .verb: return "動"
        case .adjective: return "形"
        case .adverb: return "副"
        case .idiom: return "熟"
        }
    }
    
    var jaTitle: String {
        switch self {
        case .noun: return "名詞"
        case .verb: return "動詞"
        case .adjective: return "形容詞"
        case .adverb: return "副詞"
        case .idiom: return "熟語"
        }
    }
}
