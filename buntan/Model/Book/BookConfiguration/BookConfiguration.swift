import Foundation


enum BookConfiguration {
    case frequency(FrequencyBookConfiguration)
    case partOfSpeech(PosBookConfiguration)

    var description: String? {
        switch self {
        case .frequency(let type): return type.description
        case .partOfSpeech: return nil // 品詞ブックには説明がない場合
        }
    }
    
    // カードをフィルタリングし、ブックのセクションを生成するメソッド
    func createBook(with allGradeCards: [Card]) -> Book {
        var sections: [Section] = []

        switch self {
        case .frequency(let freqType):
            // 頻度ブックの場合、全ての品詞に対してセクションを作成
            for pos in Pos.allCases { // Posは別途定義されているものとします
                let cardsForPos = allGradeCards.filter { $0.pos == pos }
                let filteredCards = freqType.filterCards(cardsForPos) // FrequencyBookCategoryでフィルタリング
                sections += generateSections(from: filteredCards, titlePrefix: pos.jaTitle, startIndex: 1)
            }
            return Book(self, sections) // Bookイニシャライザの調整が必要かもしれません

        case .partOfSpeech(let posType):
            // 品詞ブックの場合、その品詞のみでセクションを作成
            let filteredCards = posType.filterCards(allGradeCards) // PosBookCategoryでフィルタリング
            sections = generateSections(from: filteredCards, titlePrefix: "Section", startIndex: 1)
            return Book(self, sections) // Bookイニシャライザの調整が必要かもしれません
        }
    }
    
    // セクション生成のプライベートヘルパー関数 (共通化)
    private func generateSections(from cards: [Card], titlePrefix: String, startIndex: Int) -> [Section] {
        var sections: [Section] = []
        let cardsPerSection = 100
        let numberOfSections = (cards.count + cardsPerSection - 1) / cardsPerSection

        for i in 0..<numberOfSections {
            let start = i * cardsPerSection
            let end = min(start + cardsPerSection, cards.count)
            let sectionCards = Array(cards[start..<end])
            
            let sectionTitle = "\(titlePrefix) \(startIndex + i)"
            sections.append(Section(sectionTitle, sectionCards))
        }
        return sections
    }
}


extension BookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        switch self {
        case .frequency(let config): return config.title
        case .partOfSpeech(let config): return config.title
        }
    }
    
    func filterCards(_ cards: [Card]) -> [Card] {
        switch self {
        case .frequency(let config): return config.filterCards(cards)
        case .partOfSpeech(let config): return config.filterCards(cards)
        }
    }
}
