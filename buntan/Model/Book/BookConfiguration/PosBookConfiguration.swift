import Foundation


// 品詞に基づくブックの分類 (既存のPos Enumと連携)
enum PosBookConfiguration: CaseIterable {
    
    case noun
    case verb
    case adjective
    case adverb
    case idiom
    
    // この品詞タイプに対応するPos値
    var posValue: Pos {
        switch self {
        case .noun: return .noun
        case .verb: return .verb
        case .adjective: return .adjective
        case .adverb: return .adverb
        case .idiom: return .idiom
        }
    }
}


extension PosBookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        switch self {
        case .noun: return "名詞"
        case .verb: return "動詞"
        case .adjective: return "形容詞"
        case .adverb: return "副詞"
        case .idiom: return "熟語"
        }
    }
    
    // このタイプに対応するカードのフィルタリングロジック
    func filterCards(_ cards: [Card]) -> [Card] {
        return cards.filter { $0.meaning != "" && $0.pos == self.posValue }
    }
}
