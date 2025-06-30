import Foundation


extension LearnRecordRealmAPI {
    
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
}
