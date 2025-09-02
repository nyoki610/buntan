import Foundation
import FirebaseRemoteConfig


final class RemoteConfigService {
    
    enum ConfigKey: String {
        case latestDBVersionId = "latest_db_version_id"
    }
    
    static let shared = RemoteConfigService()

    private let remoteConfig: RemoteConfig
    
    private static let debugMinimumFetchInterval: TimeInterval = 0

    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        #if DEBUG
        settings.minimumFetchInterval = RemoteConfigService.debugMinimumFetchInterval
        #endif
        
        self.remoteConfig.configSettings = settings
    }
    
    internal func string(_ key: ConfigKey) async throws -> String? {
        
        try await remoteConfig.fetchAndActivate()
        let configValue = remoteConfig.configValue(forKey: key.rawValue)
        let stringValue = configValue.stringValue
        
        return stringValue.isEmpty ? nil : stringValue
    }
}
