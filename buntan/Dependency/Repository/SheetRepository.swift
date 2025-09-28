//
//  SheetRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/28.
//

import Foundation
import RealmSwift

protocol SheetRepositoryProtocol {
    func getSheet(of grade: EikenGrade) throws -> Sheet
    func updateCardList(of sheet: Sheet, with cards: [Card]) throws
}

struct SheetRepository: SheetRepositoryProtocol {
    
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
        
    func updateCardList(of sheet: Sheet, with cards: [Card]) throws {
        let realm = try realm()
        let objectId = try sheet.objectId
        guard let realmSheet = realm.object(ofType: RealmSheet.self, forPrimaryKey: objectId) else {
            throw RealmRepository.Error.objectNotFound
        }
        try realm.write {
            realmSheet.cardList.removeAll()
            let realmCards = try cards.map { try $0.toRealm(with: .newId) }
            realmSheet.cardList.append(objectsIn: realmCards)
        }
    }
}
