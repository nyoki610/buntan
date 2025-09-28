//
//  SheetUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/27.
//

import Foundation

struct SheetUseCase {
    
    let realmRepository: any RealmRepositoryProtocol
    let sheetRepository: any SheetRepositoryProtocol
    
    init(
        realmRepository: any RealmRepositoryProtocol = RealmRepository(),
        sheetRepository: any SheetRepositoryProtocol = SheetRepository()
    ) {
        self.realmRepository = realmRepository
        self.sheetRepository = sheetRepository
    }
    
    func createNewSheet(grade: EikenGrade) throws {
        let newSheet = SheetFactory.createNew(from: grade)
        try realmRepository.insert(newSheet)
    }
}
