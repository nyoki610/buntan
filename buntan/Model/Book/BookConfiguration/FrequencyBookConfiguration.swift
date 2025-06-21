import Foundation

// 頻度に基づくブックの分類
enum FrequencyBookConfiguration: CaseIterable {
    
    case freqA
    case freqB
    case freqC

    var description: String {
        switch self {
        case .freqA: return "正解として出題された単語を収録"
        case .freqB: return "複数回出題された単語を収録"
        case .freqC: return "１度だけ出題された単語を収録"
        }
    }
}


extension FrequencyBookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        switch self {
        case .freqA: return "頻出度A"
        case .freqB: return "頻出度B"
        case .freqC: return "頻出度C"
        }
    }
    
    // このタイプに対応するカードのフィルタリングロジック
    func filterCards(_ cards: [Card]) -> [Card] {
        let meaningfulCards = cards.filter { $0.meaning != "" }
        switch self {
        case .freqA: return meaningfulCards.filter { $0.priority >= 10 }
        case .freqB: return meaningfulCards.filter { $0.priority < 10 && $0.priority > 1 }
        case .freqC: return meaningfulCards.filter { $0.priority == 1 }
        }
    }
}
