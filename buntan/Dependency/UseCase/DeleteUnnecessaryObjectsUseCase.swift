//
//  DeleteUnnecessaryObjectsUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/30.
//

import Foundation

protocol DeleteUnnecessaryObjectsUseCaseProtocol {
    func execute() throws
}

struct DeleteUnnecessaryObjectsUseCase {
    
    private let repository: any RealmRepositoryProtocol
    
    init(repository: any RealmRepositoryProtocol = RealmRepository()) {
        self.repository = repository
    }
    
    func execute() throws {
        let sheets: [Sheet] = try repository.fetchAll()
        let necessaryCardIds = Set(sheets.flatMap { $0.cardList.map { $0.id } })
        let necessaryInfoIds = Set(sheets.flatMap { $0.cardList.flatMap { $0.infoList.map { $0.id } } })
        try deleteUnnecessaryObject(of: RealmCard.self, necessaryObjectIds: necessaryCardIds)
        try deleteUnnecessaryObject(of: RealmInfo.self, necessaryObjectIds: necessaryInfoIds)
    }
    
    private func deleteUnnecessaryObject<T: IdentifiableRealmObject>(
        of type: T.Type,
        necessaryObjectIds: Set<String>
    ) throws {
        let allIds = try repository.getAllIds(of: type)
        let unnecessaryObjectIds = allIds.subtracting(necessaryObjectIds)
        try repository.deleteObjects(by: unnecessaryObjectIds, of: type)
    }
}
