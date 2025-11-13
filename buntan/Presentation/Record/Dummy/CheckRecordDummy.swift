//
//  CheckRecordDummy.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/10.
//

import Foundation

struct CheckRecordDummy {
    static let shared: Self = CheckRecordDummy()
    let dummy: [CheckRecord]
    
    enum Default {
        static let daysBackLimit = 30
        static let dummyCount = 30
        static let variationLimit = 2
    }
    
    init(
        for grade: EikenGrade = .first,
        daysBackLimit: Int = Default.daysBackLimit,
        count: Int = Default.dummyCount,
        calendar: Calendar = .current
    ) {
        let dummy = (0..<count).map { _ in
            let id = UUID().uuidString
            let correctCountLimit = grade.questionCount
            let correctCount = Int.random(in: 0...correctCountLimit)
            let date = RandomDateTimeGenerator.execute(daysBackLimit: daysBackLimit, calendar: calendar)
            let estimatedCount = CheckRecordDummy.addRandomVariation(
                to: correctCount,
                variationLimit: Default.variationLimit,
                validRange: 0...correctCountLimit
            )
            return CheckRecord(
                id: id,
                grade: grade,
                date: date,
                correctCount: correctCount,
                estimatedCount: estimatedCount
            )
        }.sorted { $0.date < $1.date }
        self.dummy = dummy
    }
    
    static func addRandomVariation(
        to base: Int,
        variationLimit: Int,
        validRange: ClosedRange<Int>
    ) -> Int {
        let candidates = (-variationLimit...variationLimit).map { $0 + base }
        let validCandidates = candidates.filter { validRange.contains($0) }
        return validCandidates.randomElement() ?? base
    }
}
