import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigRepositoryProtocol {
    func string(_ key: RemoteConfigRepository.ConfigKey) async throws -> String
}

final class RemoteConfigRepository: RemoteConfigRepositoryProtocol {
    
    enum Error: Swift.Error {
        case valueNotFound
    }
    
    enum ConfigKey: String {
        case latestDBVersionId = "latest_db_version_id"
        case requiredAppVersionId = "required_app_version_id"
        case recommendedAppVersionId = "recommended_app_version_id"
    }
    
    static let shared = RemoteConfigRepository()
    private let remoteConfig: RemoteConfig
    private var isInitialized: Bool = false
    private static let debugMinimumFetchInterval: TimeInterval = 0

    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = RemoteConfigRepository.debugMinimumFetchInterval
        #endif
        self.remoteConfig.configSettings = settings
    }
    
    internal func string(_ key: ConfigKey) async throws -> String {
        if !isInitialized {
            try await remoteConfig.fetchAndActivate()
            isInitialized = true
        }
        let configValue = remoteConfig.configValue(forKey: key.rawValue)
        guard case .remote = configValue.source else {
            throw Error.valueNotFound
        }
        let stringValue = configValue.stringValue
        #if DEBUG
        print("FirebaseRemoteConfig \(key.rawValue): \(stringValue)")
        #endif
        return stringValue
    }
}
