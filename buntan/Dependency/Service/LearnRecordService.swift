//
//  LearnRecordService.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/24.
//

import Foundation

protocol LearnRecordServiceProtocol {
    func getDailyLearnRecords() throws -> [LearnRecord]
    func getTodaysWordCount() throws -> Int
}

struct LearnRecordService: LearnRecordServiceProtocol {
    
    private let repository: any RealmRepositoryProtocol
    
    init(repository: any RealmRepositoryProtocol = RealmRepository()) {
        self.repository = repository
    }
    
    func getDailyLearnRecords() throws -> [LearnRecord] {
        let records: [LearnRecord] = try repository.fetchAll()
        let aggregatedRecords = aggregateByDate(records: records)
        return aggregatedRecords
    }
    
    func getTodaysWordCount() throws -> Int {
        let records: [LearnRecord] = try repository.fetchAll()
        let count = countTodaysWord(from: records)
        return count
    }

    private func aggregateByDate(records: [LearnRecord]) -> [LearnRecord] {

        return Dictionary(
            grouping: records,
            by: { Calendar.current.startOfDay(for: $0.date) }
        )
        .mapValues { $0.reduce(0) { $0 + $1.learnedCardCount } }
        .map { LearnRecord(id: UUID().uuidString, date: $0.key, learnedCardCount: $0.value) }
        .sorted { $0.date < $1.date }
    }
    
    private func countTodaysWord(from records: [LearnRecord], calendar: Calendar = .current, today: Date = Date()) -> Int {
        
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
