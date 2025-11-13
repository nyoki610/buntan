import Foundation

protocol AppConfigProtocol {
    
    var apiKey: String? { get }
    var baseURL: String? { get }
}

struct AppConfig: AppConfigProtocol {
    
    static let shared = AppConfig()
    
    let apiKey: String?
    let baseURL: String?
    
    private enum Key: String {
        case apiKey = "API_KEY"
        case baseURL = "API_BASE_URL"
    }
    
    private init() {
        self.apiKey = Self.readEnvironmentVariable(named: Key.apiKey.rawValue)
        self.baseURL = Self.readEnvironmentVariable(named: Key.baseURL.rawValue)?.replacingOccurrences(of: "\\", with: "")
    }
    
    private static func readEnvironmentVariable(named name: String) -> String? {

        if let value = Bundle.main.object(forInfoDictionaryKey: name) as? String {
            return value
        }
        return nil
    }
}
