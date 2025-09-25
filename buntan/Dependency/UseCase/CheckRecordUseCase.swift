//
//  CheckRecordUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/26.
//

import Foundation

protocol CheckRecordUseCaseProtocol {
    func getCheckRecords() throws -> [CheckRecord]
    func uploadCheckRecord(checkRecord: CheckRecord) throws
}

struct CheckRecordUseCase: CheckRecordUseCaseProtocol {
    
    private let repository: any RealmRepositoryProtocol
    
    init(repository: any RealmRepositoryProtocol = RealmRepository()) {
        self.repository = repository
    }
    
    func getCheckRecords() throws -> [CheckRecord] {
        try repository.fetchAll()
    }
    
    func uploadCheckRecord(checkRecord: CheckRecord) throws {
        try repository.insert(checkRecord)
    }
}
