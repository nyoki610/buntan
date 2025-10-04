//
//  CheckForcedUpdateUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/18.
//

import Foundation

protocol CheckForcedUpdateUseCaseProtocol {
    func isForcedUpdateRequired() async -> CheckForcedUpdateUseCase.RequiredUpdateType?
}

struct CheckForcedUpdateUseCase: CheckForcedUpdateUseCaseProtocol {

    struct Dependency {
        let remoteConfigRepository: any RemoteConfigRepositoryProtocol = RemoteConfigRepository.shared
        let infoPlistRepository: any InfoPlistRepositoryProtocol = InfoPlistRepository()
    }

    private let dependency: Dependency
    
    init(dependency: Dependency = .init()) {
        self.dependency = dependency
    }
    
    enum RequiredUpdateType {
        case force
        case softForce
        case notRequired
    }
    
    func isForcedUpdateRequired() async -> RequiredUpdateType? {
        
        guard let requiredAppVersionId = try? await dependency.remoteConfigRepository.string(.requiredAppVersionId) else {
            return nil
        }
        
        if isUpdateRequired(for: requiredAppVersionId) {
            return .force
        }

        guard let recommendedAppVersionId = try? await dependency.remoteConfigRepository.string(.recommendedAppVersionId) else {
            return nil
        }

        return isUpdateRequired(for: recommendedAppVersionId) ? .softForce : .notRequired
    }
    
    private func isUpdateRequired(for id: String) -> Bool {
        guard let appVersionId = dependency.infoPlistRepository.value(for: .appVersionId) else {
            return false
        }
        return appVersionId.compare(id, options: .numeric) == .orderedAscending
    }
}
