//
//  LocalDBVersionRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

protocol LocalDBVersionRepositoryProtocol {
    func getValue(forKey key: LocalDBVersionRepository.Key) -> String?
    func setValue(value: String, forKey key: LocalDBVersionRepository.Key)
}

struct LocalDBVersionRepository: LocalDBVersionRepositoryProtocol {
    
    enum Key: String {
        case usersCardsVersionId
    }

    func getValue(forKey key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    func setValue(value: String, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
