//import Foundation
//
//
//extension SheetHandler {
//    
//    func getBookListByGradeAndBookConfiguration(grade: EikenGrade, bookDesign: BookConfiguration) -> Book {
//
//        let allCardsForGrade: [Card] // Explicitly declare type if needed
//
//        switch grade {
//        case .first:
//            allCardsForGrade = self.firstGradeCards
//        case .preFirst:
//            allCardsForGrade = self.preFirstGradeCards
//        // Ensure all cases are handled, or provide a default
//        }
//        
//        var sections: [Section] = []
//        let isFrequencyBasedBook = bookDesign.bookCategory == .freq
//
//        if isFrequencyBasedBook {
//            /// 頻度ベースのブックの場合、すべての品詞 (Pos) に対してセクションを作成
//            for pos in Pos.allCases {
//                let cardsForPos = filterCards(allCardsForGrade, by: pos, for: bookDesign)
//                sections += createSections(from: cardsForPos, namedByPos: pos, isFrequencyBased: true)
//            }
//        } else {
//            /// 特定の品詞ベースのブックの場合、その品詞のみでセクションを作成
//            guard let targetPos = bookDesign.convertToPos else {
//                return EmptyModel.book /// 変換できない場合は空のブックを返す
//            }
//            let cardsForTargetPos = filterCards(allCardsForGrade, by: targetPos, for: bookDesign)
//            sections = createSections(from: cardsForTargetPos, namedByPos: targetPos, isFrequencyBased: false)
//        }
//
//        return Book(bookDesign, sections)
//    }
//
//    // --- プライベートヘルパー関数 ---
//
//    // カードを品詞とブックデザインに基づいてフィルタリングする
//    private func filterCards(_ cards: [Card], by pos: Pos, for bookDesign: BookConfiguration) -> [Card] {
//        let meaningfulCardsOfPos = cards.filter { $0.meaning != "" && $0.pos == pos }
//
//        switch bookDesign {
//        case .freqA: return meaningfulCardsOfPos.filter { $0.priority >= 10 }
//        case .freqB: return meaningfulCardsOfPos.filter { $0.priority < 10 && $0.priority > 1 }
//        case .freqC: return meaningfulCardsOfPos.filter { $0.priority == 1 }
//        case .noun, .verb, .adjective, .adverb, .idiom: return meaningfulCardsOfPos
//        }
//    }
//
//    // カードのリストを100枚ごとのセクションに分割し、セクション名を設定する
//    private func createSections(from cards: [Card], namedByPos pos: Pos, isFrequencyBased: Bool) -> [Section] {
//        var sections: [Section] = []
//        let cardsPerSection = 100
//        let numberOfSections = (cards.count + cardsPerSection - 1) / cardsPerSection // より堅牢な切り上げ計算
//
//        for i in 0..<numberOfSections {
//            let startIndex = i * cardsPerSection
//            let endIndex = min(startIndex + cardsPerSection, cards.count)
//            let sectionCards = Array(cards[startIndex..<endIndex])
//
//            let sectionTitle = isFrequencyBased ? "\(pos.jaTitle) \(i + 1)" : "Section \(i + 1)"
//            sections.append(Section(sectionTitle, sectionCards))
//        }
//        return sections
//    }
//}
