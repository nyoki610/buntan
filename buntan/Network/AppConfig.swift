import Foundation


enum AppConfig {
    
    private static func readEnvironmentVariable<T> (named name: String) -> T? {
        // まずInfo.plistから読み取りを試行
        if let value = Bundle.main.object(forInfoDictionaryKey: name) as? T {
            return value
        }
        return nil
    }
        
    static var apiKey: String? {
        readEnvironmentVariable(named: "API_KEY")
    }
    
    static var baseURL: String? {
        guard let urlString: String = readEnvironmentVariable(named: "API_BASE_URL") else {
            return nil
        }
        let cleanedURL = urlString.replacingOccurrences(of: "\\", with: "")
        return cleanedURL
    }
    
    static var getLatestCardsPath: String? {
        guard let path: String = readEnvironmentVariable(named: "LATEST_CARDS_PATH") else {
            return nil
        }
        let cleanedPath = path.replacingOccurrences(of: "\\", with: "")
        return cleanedPath
    }
    
    static var getLatestVersionPath: String? {
        guard let path: String = readEnvironmentVariable(named: "LATEST_VERSION_PATH") else {
            return nil
        }
        let cleanedPath = path.replacingOccurrences(of: "\\", with: "")
        return cleanedPath
    }
}
