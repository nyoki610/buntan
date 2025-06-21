////
////  _BookDesign.swift
////  buntan
////
////  Created by 二木裕也 on 2025/06/20.
////
//
//enum _BookDesign {
//    case frequency(FrequencyBookCategory)
//    case partOfSpeech(PosBookCategory)
//
//    var title: String {
//        switch self {
//        case .frequency(let type): return type.title
//        case .partOfSpeech(let type): return type.title
//        }
//    }
//
//    var description: String? {
//        switch self {
//        case .frequency(let type): return type.description
//        case .partOfSpeech: return nil // 品詞ブックには説明がない場合
//        }
//    }
//    
//    // カードをフィルタリングし、ブックのセクションを生成するメソッド
//    func createBook(with allGradeCards: [Card]) -> Book {
//        var sections: [Section] = []
//
//        switch self {
//        case .frequency(let freqType):
//            // 頻度ブックの場合、全ての品詞に対してセクションを作成
//            for pos in Pos.allCases { // Posは別途定義されているものとします
//                let cardsForPos = allGradeCards.filter { $0.pos == pos }
//                let filteredCards = freqType.filterCards(cardsForPos) // FrequencyBookCategoryでフィルタリング
//                sections += generateSections(from: filteredCards, titlePrefix: pos.jaTitle, startIndex: 1)
//            }
//            return Book(self, sections) // Bookイニシャライザの調整が必要かもしれません
//
//        case .partOfSpeech(let posType):
//            // 品詞ブックの場合、その品詞のみでセクションを作成
//            let filteredCards = posType.filterCards(allGradeCards) // PosBookCategoryでフィルタリング
//            sections = generateSections(from: filteredCards, titlePrefix: "Section", startIndex: 1)
//            return Book(self, sections) // Bookイニシャライザの調整が必要かもしれません
//        }
//    }
//    
//    // セクション生成のプライベートヘルパー関数 (共通化)
//    private func generateSections(from cards: [Card], titlePrefix: String, startIndex: Int) -> [Section] {
//        var sections: [Section] = []
//        let cardsPerSection = 100
//        let numberOfSections = (cards.count + cardsPerSection - 1) / cardsPerSection
//
//        for i in 0..<numberOfSections {
//            let start = i * cardsPerSection
//            let end = min(start + cardsPerSection, cards.count)
//            let sectionCards = Array(cards[start..<end])
//            
//            let sectionTitle = "\(titlePrefix) \(startIndex + i)"
//            sections.append(Section(sectionTitle, sectionCards))
//        }
//        return sections
//    }
//}
//
//
//// 頻度に基づくブックの分類
//enum FrequencyBookCategory: CaseIterable {
//    case freqA
//    case freqB
//    case freqC
//
//    var title: String {
//        switch self {
//        case .freqA: return "頻出度A"
//        case .freqB: return "頻出度B"
//        case .freqC: return "頻出度C"
//        }
//    }
//
//    var description: String {
//        switch self {
//        case .freqA: return "正解として出題された単語を収録"
//        case .freqB: return "複数回出題された単語を収録"
//        case .freqC: return "１度だけ出題された単語を収録"
//        }
//    }
//    
//    // このタイプに対応するカードのフィルタリングロジック
//    func filterCards(_ cards: [Card]) -> [Card] {
//        let meaningfulCards = cards.filter { $0.meaning != "" }
//        switch self {
//        case .freqA: return meaningfulCards.filter { $0.priority >= 10 }
//        case .freqB: return meaningfulCards.filter { $0.priority < 10 && $0.priority > 1 }
//        case .freqC: return meaningfulCards.filter { $0.priority == 1 }
//        }
//    }
//}
//
//// 品詞に基づくブックの分類 (既存のPos Enumと連携)
//enum PosBookCategory: CaseIterable { // Pos EnumがCaseIterableと仮定
//    case noun
//    case verb
//    case adjective
//    case adverb
//    case idiom
//
//    var title: String {
//        switch self {
//        case .noun: return "名詞"
//        case .verb: return "動詞"
//        case .adjective: return "形容詞"
//        case .adverb: return "副詞"
//        case .idiom: return "熟語"
//        }
//    }
//    
//    // この品詞タイプに対応するPos値
//    var posValue: Pos {
//        switch self {
//        case .noun: return .noun
//        case .verb: return .verb
//        case .adjective: return .adjective
//        case .adverb: return .adverb
//        case .idiom: return .idiom
//        }
//    }
//    
//    // このタイプに対応するカードのフィルタリングロジック
//    func filterCards(_ cards: [Card]) -> [Card] {
//        return cards.filter { $0.meaning != "" && $0.pos == self.posValue }
//    }
//}
