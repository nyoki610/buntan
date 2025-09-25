//
//  LearnRecordUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/25.
//

import Foundation

protocol LearnRecordUseCaseProtocol {
    func getDailyLearnRecords() throws -> [LearnRecord]
    func getTodaysWordCount() throws -> Int
    func uploadLearnRecord(record: LearnRecord) throws
}

struct LearnRecordUseCase: LearnRecordUseCaseProtocol {
    
    private let repository: any RealmRepositoryProtocol
    private let service: any LearnRecordServiceProtocol
    
    init(
        repository: any RealmRepositoryProtocol = RealmRepository(),
        service: any LearnRecordServiceProtocol = LearnRecordService()
    ) {
        self.repository = repository
        self.service = service
    }
    
    func getDailyLearnRecords() throws -> [LearnRecord] {
        let records: [LearnRecord] = try repository.fetchAll()
        let aggregatedRecords = service.aggregateByDate(records: records)
        return aggregatedRecords
    }
    
    func getTodaysWordCount() throws -> Int {
        let records: [LearnRecord] = try repository.fetchAll()
        let count = service.countTodaysWord(from: records)
        return count
    }
    
    func uploadLearnRecord(record: LearnRecord) throws {
        try repository.insert(record)
    }
}
