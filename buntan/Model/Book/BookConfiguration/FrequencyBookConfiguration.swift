import Foundation

// 頻度に基づくブックの分類
enum FrequencyBookConfiguration: CaseIterable {
    
    case freqA
    case freqB
    case freqC

    /// Only FreqBookConfig has (PosBookConfig does not)
    var description: String {
        switch self {
        case .freqA: return "「正解」として出題された単語を収録"
        case .freqB: return "「複数回」出題された単語を収録"
        case .freqC: return "出題回数の少ない単語を収録"
        }
    }
    
    // このタイプに対応するカードのフィルタリングロジック
    func filterCardsByFreq(cards: [Card]) -> [Card] {
        let meaningfulCards = cards.filter { $0.meaning != "" }
        switch self {
        case .freqA: return meaningfulCards.filter { $0.priority >= 10 }
        case .freqB: return meaningfulCards.filter { $0.priority < 10 && $0.priority > 1 }
        case .freqC: return meaningfulCards.filter { $0.priority == 1 }
        }
    }
}


extension FrequencyBookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        
        var freqCharacter: String {
            switch self {
            case .freqA: return "A"
            case .freqB: return "B"
            case .freqC: return "C"
            }
        }
        let title = "頻出度" + freqCharacter
        
        return title
    }
}
