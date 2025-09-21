//
//  CheckForcedUpdateUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/18.
//

import Foundation

struct CheckForcedUpdateUseCase {
    
    static func isUpdateRequired() async -> Bool {
        
        guard let appVersionId = InfoPlistRepository.value(for: .appVersionId),
              let requiredAppVersionId = try? await RemoteConfigService.shared.string(.requiredAppVersionId) else {
            return false
        }
        
        let result = appVersionId.compare(requiredAppVersionId, options: .numeric)
        
        return result == .orderedAscending
    }
}
