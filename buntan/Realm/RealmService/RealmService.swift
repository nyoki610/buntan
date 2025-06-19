import Foundation

class RealmService: ObservableObject {
    
    @Published var sheetDict: [EikenGrade: Sheet] = [:]

    var booksDict: [EikenGrade: [BookDesign: Book]]? {

        var dict: [EikenGrade: [BookDesign: Book]] = [:]

        /// EikenGrade.allCasesに要修正
        for grade in [EikenGrade.first]  {
            if let sheet = self.sheetDict[grade] {
                var innerDict: [BookDesign: Book] = [:]
                for design in BookDesign.allCases {
                    innerDict[design] = design.book(sheet.cardList)
                }
                dict[grade] = innerDict
            }
        }
        return dict
    }

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
