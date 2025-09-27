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
        case failedToConvertToNonRealm
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
        let objects = realm.objects(T.RealmObjectType.self)
        return try objects.map {
            guard let nonRealmObject = $0.toNonRealm() else {
                throw Error.failedToConvertToNonRealm
            }
            return nonRealmObject
        }
    }
    
    func insert<T: RealmConvertible>(_ nonRealmObject: T) throws {
        let realm = try realm()
        try realm.write {
            let realmObject = try nonRealmObject.toRealm(with: .newId)
            realm.add(realmObject, update: .error)
        }
    }
    
    func insertAll<T: RealmConvertible>(_ nonRealmObjects: [T]) throws {
        let realm = try realm()
        try realm.write {
            for nonRealmObject in nonRealmObjects {
                let realmObject = try nonRealmObject.toRealm(with: .newId)
                realm.add(realmObject, update: .error)
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
            let newRealmObject = try nonRealmObject.toRealm(with: .existingId)
            realm.add(newRealmObject, update: .modified)
        }
    }
}

// MARK: - RealmConvertible
protocol RealmConvertible: IdentifiableNonRealmObject {
    associatedtype RealmObjectType: NonRealmConvertible where RealmObjectType.NonRealmType == Self
    func toRealm(with idType: RealmIdType) throws -> RealmObjectType
}

extension RealmConvertible {
    
    func setId(to object: RealmObjectType, idType: RealmIdType) throws {
        if idType == .existingId {
            object.id = try ObjectId(string: id)
        }
    }
}

enum RealmIdType {
    case newId
    case existingId
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
    func toNonRealm() -> NonRealmType?
}

protocol IdentifiableRealmObject: Object {
    var id: ObjectId { get set }
}
