//
//  LearnRecordService.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/24.
//

import Foundation

protocol LearnRecordServiceProtocol {
    func aggregateByDate(records: [LearnRecord]) -> [LearnRecord]
    func countTodaysWord(from records: [LearnRecord], calendar: Calendar, today: Date) -> Int
}

extension LearnRecordServiceProtocol {
    func countTodaysWord(from records: [LearnRecord], calendar: Calendar = .current, today: Date = Date()) -> Int {
        countTodaysWord(from: records, calendar: calendar, today: today)
    }
}

struct LearnRecordService: LearnRecordServiceProtocol {

    func aggregateByDate(records: [LearnRecord]) -> [LearnRecord] {

        return Dictionary(
            grouping: records,
            by: { Calendar.current.startOfDay(for: $0.date) }
        )
        .mapValues { $0.reduce(0) { $0 + $1.learnedCardCount } }
        .map { LearnRecord(id: UUID().uuidString, date: $0.key, learnedCardCount: $0.value) }
        .sorted { $0.date < $1.date }
    }
    
    func countTodaysWord(from records: [LearnRecord], calendar: Calendar = .current, today: Date = Date()) -> Int {
        
        let todayComponents = ymdComponents(of: today, using: calendar)
        let count = records
            .filter { ymdComponents(of: $0.date, using: calendar) == todayComponents }
            .reduce(0) { $0 + $1.learnedCardCount }
        
        return count
    }
    
    private func ymdComponents(of date: Date, using calendar: Calendar = .current) -> DateComponents {
        return calendar.dateComponents([.year, .month, .day], from: date)
    }
}
