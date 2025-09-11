import Foundation

protocol AppConfigProtocol {
    
    var apiKey: String? { get }
    var baseURL: String? { get }
    var getLatestCardsPath: String? { get }
    var getLatestVersionPath: String? { get }
}

struct AppConfig: AppConfigProtocol {
    
    static let shared = AppConfig()
    
    let apiKey: String?
    let baseURL: String?
    let getLatestCardsPath: String?
    let getLatestVersionPath: String?
    
    private enum Key: String {
        case API_KEY
        case API_BASE_URL
        case LATEST_CARDS_PATH
        case LATEST_VERSION_PATH
    }
    
    private init() {
        self.apiKey = Self.readEnvironmentVariable(named: Key.API_KEY.rawValue)
        self.baseURL = Self.readEnvironmentVariable(named: Key.API_BASE_URL.rawValue)?.replacingOccurrences(of: "\\", with: "")
        self.getLatestCardsPath = Self.readEnvironmentVariable(named: Key.LATEST_CARDS_PATH.rawValue)?.replacingOccurrences(of: "\\", with: "")
        self.getLatestVersionPath = Self.readEnvironmentVariable(named: Key.LATEST_VERSION_PATH.rawValue)?.replacingOccurrences(of: "\\", with: "")
    }
    
    private static func readEnvironmentVariable(named name: String) -> String? {

        if let value = Bundle.main.object(forInfoDictionaryKey: name) as? String {
            return value
        }
        return nil
    }
}
