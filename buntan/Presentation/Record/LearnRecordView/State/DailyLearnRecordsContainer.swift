//
//  LearnRecordView+DailyLearnRecordsContainer.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/09.
//

import Foundation

struct DailyLearnRecordsContainer {
    var dailyLearnRecords: [LearnRecord] = []
    var allCount: Int { dailyLearnRecords.reduce(0) { $0 + $1.learnedCardCount } }
    
    /// The earliest date for which LearnRecord exists
    var earliest: Date { dailyLearnRecords.first?.date ?? Date() }
    
    /// The most recent date for which LearnRecord exists
    var latest: Date { dailyLearnRecords.last?.date ?? Date() }
}
