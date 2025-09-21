//
//  InfoPlistRepository.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/18.
//

import Foundation

struct InfoPlistRepository {
    
    enum Key: String {
        case appVersionId = "CFBundleShortVersionString"
    }

    static func value(for key: Key) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
}
