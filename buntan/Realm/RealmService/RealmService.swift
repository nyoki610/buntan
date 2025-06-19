import Foundation

class RealmService: ObservableObject {
    
    @Published var sheets: [Sheet] = []

    var booksByGradeAndType: [[Book]]? {
        Eiken.allCases.compactMap { grade in
            guard let sheet = self.sheets.first(where: { $0.grade == grade }) else { return nil }
            return BookDesign.allCases.map { $0.book(sheet.cardList) }
        }
    }
    
    func convertGradeToSheet(_ grade: Eiken) -> Sheet? {
        sheets.first(where: { $0.grade == grade })
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
