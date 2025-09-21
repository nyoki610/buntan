import Foundation
import FirebaseRemoteConfig


final class RemoteConfigRepository {
    
    enum ConfigKey: String {
        case latestDBVersionId = "latest_db_version_id"
        case requiredAppVersionId = "required_app_version_id"
    }
    
    static let shared = RemoteConfigRepository()

    private let remoteConfig: RemoteConfig
    
    private var isActivated: Bool = false
    
    private static let debugMinimumFetchInterval: TimeInterval = 0

    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        #if DEBUG
        settings.minimumFetchInterval = RemoteConfigRepository.debugMinimumFetchInterval
        #endif
        
        self.remoteConfig.configSettings = settings
    }
    
    internal func string(_ key: ConfigKey) async throws -> String? {

        if !isActivated {
            try await remoteConfig.fetchAndActivate()
            isActivated = true
        }
        
        let configValue = remoteConfig.configValue(forKey: key.rawValue)
        let stringValue = configValue.stringValue
        
        return stringValue.isEmpty ? nil : stringValue
    }
}
