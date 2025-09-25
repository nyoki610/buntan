//import Foundation
//
//
//extension LearnRecordRealmAPI {
//
//    static func getDailyLearnRecords() -> [LearnRecord]? {
//        
//        guard let learnRecords = LearnRecordRealmCruds.getLearnRecords() else { return nil }
//        
//        /// 以下のDictionaryを作成 (key: 日付(2025/01/20 00:00:00), value:[LearnRecord])
//        return Dictionary(
//            grouping: learnRecords,
//            by: { Calendar.current.startOfDay(for: $0.date) }
//        )
//            /// mapValues: 辞書の各値に対して指定されたクロージャを適用し、新しいvalueに変換する
//            /// Dictionaryのvalueを[LearnRecord]->cardCountの合計値に変換
//            .mapValues { $0.reduce(0) { $0 + $1.learnedCardCount } }
//            
//            /// 変換後のDictionaryの各key, valueを用いてLearnRecordを再生成
//            .map { LearnRecord(
//                id: UUID().uuidString,
//                date: $0.key,
//                learnedCardCount: $0.value
//            ) }
//        
//            /// 日付順にsort
//            .sorted { $0.date < $1.date }
//    }
//}
