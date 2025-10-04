//
//  InfoPlistRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/18.
//

import Foundation

protocol InfoPlistRepositoryProtocol {
    func value(for key: InfoPlistRepository.Key) -> String?
}

struct InfoPlistRepository: InfoPlistRepositoryProtocol {
    
    enum Key: String {
        case appVersionId = "CFBundleShortVersionString"
    }

    func value(for key: Key) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
