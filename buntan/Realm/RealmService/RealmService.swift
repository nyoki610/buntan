import Foundation

class RealmService: ObservableObject {
    
    @Published var sheetDict: [EikenGrade: Sheet] = [:]
    
//    var allCardsCount: Int {
//        guard let realm = tryRealm() else { return 0 }
//        let realmCards = realm.objects(RealmCard.self)
//        return realmCards.count
//    }

    var booksDict: [EikenGrade: [BookConfiguration: Book]]? {

        var dict: [EikenGrade: [BookConfiguration: Book]] = [:]

        /// EikenGrade.allCasesに要修正
        for grade in [EikenGrade.first]  {
            if let sheet = self.sheetDict[grade] {
                var innerDict: [BookConfiguration: Book] = [:]
                for config in BookConfiguration.allCases {
                    innerDict[config] = book(cards: sheet.cardList, bookConfig: config)
                }
                dict[grade] = innerDict
            }
        }
        return dict
    }
    
    ///------------------------------------------------------
    func book(cards: [Card], bookConfig: BookConfiguration) -> Book {
        switch bookConfig {
        case .frequency(let freqConfig):
            let filteredCards = freqConfig.filterCardsByFreq(cards: cards)
            var sections: [Section] = []
            for pos in Pos.allCases {
                sections += getSections(cards: filteredCards, pos: pos, isFreq: true)
            }
            return Book(config: bookConfig, sections: sections)
        case .pos(let posConfig):
            
            return Book(config: bookConfig, sections: getSections(cards: cards, pos: posConfig.posValue, isFreq: false))
        }
    }
    
    private func getSections(cards: [Card], pos: Pos, isFreq: Bool) -> [Section] {
        
        let filteredCards = filterCardsByPos(cards: cards, pos: pos)
        
        var sections: [Section] = []
        let sectionCount = (filteredCards.count + 99) / 100

        for i in 0..<sectionCount {
            let start = i * 100
            let end = min((i + 1) * 100, filteredCards.count)
            sections.append(Section(title: isFreq ? "\(pos.jaTitle) \(i + 1)" : "Section \(i + 1)",
                                    cards: Array(filteredCards[start..<end])))
        }
        return sections
    }
    
    private func filterCardsByPos(cards: [Card], pos: Pos) -> [Card] {
        let filteredCards = cards.filter { $0.meaning != "" && $0.pos == pos}
        return filteredCards
    }
    ///------------------------------------------------------

    func convertGradeToSheet(_ grade: EikenGrade) -> Sheet? {
        sheetDict[grade]
    }
    
    @Published var learnRecords: [LearnRecord] = []
    @Published var checkRecords: [CheckRecord] = []
    
    /// LearnRecordを日付ごとにグルーピングする
    var combinedRecords: [LearnRecord] {
        /// 以下のDictionaryを作成 (key: 日付(2025/01/20 00:00:00), value:[LearnRecord])
        Dictionary(grouping: learnRecords, by: { Calendar.current.startOfDay(for: $0.date) })
        
            /// mapValues: 辞書の各値に対して指定されたクロージャを適用し、新しいvalueに変換する
            /// Dictionaryのvalueを[LearnRecord]->cardCountの合計値に変換
            .mapValues { $0.reduce(0) { $0 + $1.learnedCardCount } }
            
            /// 変換後のDictionaryの各key, valueを用いてLearnRecordを再生成
            .map { LearnRecord(UUID().uuidString, $0.key, $0.value) }
        
            /// 日付順にsort
            .sorted { $0.date < $1.date }
    }
    
    init() {
        setupRealmFile()
        fetchRealmObjects()
    }
}
