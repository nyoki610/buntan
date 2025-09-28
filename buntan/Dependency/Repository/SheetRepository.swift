//
//  SheetRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/28.
//

import Foundation
import RealmSwift

struct SheetRepository {
    
    private let repository: any RealmRepositoryProtocol
    
    init(repository: any RealmRepositoryProtocol = RealmRepository()) {
        self.repository = repository
    }
    
    private func realm() throws -> Realm {
        try repository.realm()
    }
    
    func getSheet(of grade: EikenGrade) throws -> Sheet {
        let realm = try realm()
        guard let realmSheet = realm
            .objects(RealmSheet.self)
            .filter("gradeRawValue == %@", grade.rawValue)
            .first else {
            throw RealmRepository.Error.objectNotFound
        }
        return try realmSheet.toNonRealm()
    }
}
