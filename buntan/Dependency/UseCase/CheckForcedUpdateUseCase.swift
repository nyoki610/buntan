//
//  CheckForcedUpdateUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/18.
//

import Foundation

struct CheckForcedUpdateUseCase {
    
    enum RequiredUpdateType {
        case force
        case softForce
        case notRequired
    }
    
    static func isForcedUpdateRequired() async -> RequiredUpdateType? {
        
        guard let requiredAppVersionId = try? await RemoteConfigRepository.shared.string(.requiredAppVersionId) else {
            return nil
        }
        
        if isUpdateRequired(for: requiredAppVersionId) {
            return .force
        }

        guard let recommendedAppVersionId = try? await RemoteConfigRepository.shared.string(.recommendedAppVersionId) else {
            return nil
        }

        return isUpdateRequired(for: recommendedAppVersionId) ? .softForce : .notRequired
    }
    
    private static func isUpdateRequired(for id: String) -> Bool {
        guard let appVersionId = InfoPlistRepository.value(for: .appVersionId) else {
            return false
        }
        return appVersionId.compare(id, options: .numeric) == .orderedAscending
    }
}
