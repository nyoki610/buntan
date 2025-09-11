import Foundation

extension APIHandler {
    
    static func getLatestVersion() async throws -> String {

        guard let getLatestVersionPath = AppConfig.shared.getLatestVersionPath,
              let resultJson = await callAPI(path: getLatestVersionPath, method: .get) else {
            throw APIError.invalidJSON
        }
        
        guard let latestVersionId = resultJson["latest_version_id"] as? String else {
            throw APIError.invalidJSON
        }
        
        return latestVersionId
    }
}
