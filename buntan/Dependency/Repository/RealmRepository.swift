//
//  RealmRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/23.
//

import Foundation
import RealmSwift

protocol RealmRepositoryProtocol {
    func fetchAll<T: RealmConvertible>() throws -> [T]
    func insert<T: RealmConvertible>(_ object: T) throws
    func insertAll<T: RealmConvertible>(_ objects: [T]) throws
    func update<T: RealmConvertible>(_ nonRealmObject: T) throws
}

struct RealmRepository: RealmRepositoryProtocol {
    
    enum Error: Swift.Error {
        case failedToGetRealmURL
        case objectNotFound
    }
    
    private let schemaVersion: UInt64 = 1
    private let fileName = "myrealm.realm"
    
    private func realm() throws -> Realm {
        
        guard let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(fileName) else {
            throw Error.failedToGetRealmURL
        }
        
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: schemaVersion)
        let userRealm = try Realm(configuration: config)
        
        return userRealm
    }
    
    func fetchAll<T: RealmConvertible>() throws -> [T] {
        let realm = try realm()
        return Array(realm.objects(T.RealmObjectType.self).map { $0.toNonRealm() })
    }
    
    func insert<T: RealmConvertible>(_ object: T) throws {
        let realm = try realm()
        try realm.write {
            realm.add(object.toRealmWithNewId(), update: .error)
        }
    }
    
    func insertAll<T: RealmConvertible>(_ objects: [T]) throws {
        let realm = try realm()
        try realm.write {
            for object in objects {
                realm.add(object.toRealmWithNewId(), update: .error)
            }
        }
    }
    
    /// 不要かも
    func update<T: RealmConvertible>(_ nonRealmObject: T) throws {
        let realm = try realm()
        let objectId = try nonRealmObject.objectId
        guard realm.object(ofType: T.RealmObjectType.self, forPrimaryKey: objectId) != nil else {
            throw Error.objectNotFound
        }
        try realm.write {
            let newRealmObject = try nonRealmObject.toRealmWithExistingId()
            realm.add(newRealmObject, update: .modified)
        }
    }
}

// MARK: - RealmConvertible
protocol RealmConvertible: IdentifiableNonRealmObject {
    associatedtype RealmObjectType: NonRealmConvertible where RealmObjectType.NonRealmType == Self
    func toRealmWithExistingId() throws -> RealmObjectType
    func toRealmWithNewId() -> RealmObjectType
}

extension RealmConvertible {
    func toRealmWithExistingId() throws -> RealmObjectType {
        let realmObject = toRealmWithNewId()
        realmObject.id = try ObjectId(string: id)
        return realmObject
    }
}

// MARK: - IdentifiableNonRealmObject
protocol IdentifiableNonRealmObject {
    var id: String { get }
}

extension IdentifiableNonRealmObject {
    var objectId: ObjectId { get throws { try ObjectId(string: id) } }
}

// MARK: - NonRealmConvertible
protocol NonRealmConvertible: IdentifiableRealmObject {
    associatedtype NonRealmType
    func toNonRealm() -> NonRealmType
}

protocol IdentifiableRealmObject: Object {
    var id: ObjectId { get set }
}
