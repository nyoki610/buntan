//
//  LearnRecordDummy.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import Foundation

struct LearnRecordDummy {
    static let shared: Self = LearnRecordDummy()
    let dummy: [LearnRecord]
    
    enum Default {
        static let daysBackLimit = 30
        static let dummyCount = 30
        static let learnedCardCountLimit = 300
    }
    
    init(
        daysBackLimit: Int = Default.daysBackLimit,
        count: Int = Default.dummyCount,
        calendar: Calendar = .current
    ) {
        let dummy = (0..<count).map { _ in
            let id = UUID().uuidString
            let date = RandomDateTimeGenerator.execute(daysBackLimit: daysBackLimit, calendar: calendar)
            let learnedCardCount = Int.random(in: 0...Default.learnedCardCountLimit)
            return LearnRecord(
                id: id,
                date: date,
                learnedCardCount: learnedCardCount
            )
        }.sorted { $0.date < $1.date }
        self.dummy = dummy
    }
}
