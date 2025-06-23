import Foundation


enum LearnRecordRealmAPI {
    
    private static func getLearnRecords() -> [LearnRecord]? {
        return LearnRecordRealmCruds.getLearnRecords()
    }
    
    static func getDailyLearnRecords() -> [LearnRecord]? {
        
        guard let learnRecords = getLearnRecords() else { return nil }
        
        /// 以下のDictionaryを作成 (key: 日付(2025/01/20 00:00:00), value:[LearnRecord])
        return Dictionary(
            grouping: learnRecords,
            by: { Calendar.current.startOfDay(for: $0.date) }
        )
            /// mapValues: 辞書の各値に対して指定されたクロージャを適用し、新しいvalueに変換する
            /// Dictionaryのvalueを[LearnRecord]->cardCountの合計値に変換
            .mapValues { $0.reduce(0) { $0 + $1.learnedCardCount } }
            
            /// 変換後のDictionaryの各key, valueを用いてLearnRecordを再生成
            .map { LearnRecord(UUID().uuidString, $0.key, $0.value) }
        
            /// 日付順にsort
            .sorted { $0.date < $1.date }
    }
    
    static func getTodaysWordCount() -> Int? {
        
        /// combinedRecords が取得できない場合
        guard let combinedRecords = getDailyLearnRecords() else { return nil }
        
        /// 取得できたが, 空の場合
        guard let lastRecord = combinedRecords.last else { return 0 }
        
        let lastRecordDate = Calendar
            .current
            .dateComponents(
                [.year, .month, .day],
                from: lastRecord.date
            )
        
        let today = Calendar
            .current
            .dateComponents(
                [.year, .month, .day],
                from: Date()
            )
        
        /// 最新の record が今日のものでなければ 0 を返す
        return lastRecordDate == today ? lastRecord.learnedCardCount : 0
    }
    
    static func uploadLearnRecord(learnRecord: LearnRecord) -> Bool {
        LearnRecordRealmCruds.uploadLearnRecord(learnRecord: learnRecord)
    }
}
