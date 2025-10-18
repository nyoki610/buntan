//
//  LearnRecordChartState.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/09.
//

import Foundation

struct LearnRecordChartState {
    private let weekOffsetCount: Int
    private let dailyLearnRecords: [LearnRecord]
    private let latestSunday: Date
    
    init(weekOffsetCount: Int, dailyLearnRecords: [LearnRecord], latestSunday: Date) {
        self.weekOffsetCount = weekOffsetCount
        self.dailyLearnRecords = dailyLearnRecords
        self.latestSunday = latestSunday
    }
    
    /// computed properties
    var sevenDaysRecords: [LearnRecord] { extractSevenDaysRecords(from: dailyLearnRecords, weekStartDate: weekStartDate) }
    var sevenDaysCount: Int { sevenDaysRecords.reduce(0) { $0 + $1.learnedCardCount } }
    var weekStartDate: Date {
        let dateCountOffset = -7 * weekOffsetCount
        return Calendar.current.date(byAdding: .day, value: dateCountOffset, to: latestSunday) ?? Date()
    }
    var yearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: weekStartDate)
    }

    private func extractSevenDaysRecords(from dailyLearnRecords: [LearnRecord], weekStartDate: Date) -> [LearnRecord] {
        let dayOffsets = (0..<7)
        return dayOffsets.map { dayOffset in
            guard let targetDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: weekStartDate) else {
                return LearnRecord(id: UUID().uuidString, date: Date(), learnedCardCount: 0)
            }
            return dailyLearnRecords
                .first { learnRecord in
                    Calendar.current.isDate(learnRecord.date, inSameDayAs: targetDate)
                } ?? LearnRecord(id: UUID().uuidString, date: targetDate, learnedCardCount: 0)
        }
    }
}
