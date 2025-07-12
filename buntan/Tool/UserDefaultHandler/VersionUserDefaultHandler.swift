import Foundation

enum VersionUserDefaultHandler {
    
    static var key: String = "usersCardsVersionId"

    static func getUsersCardsVersionId() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    static func saveUsersCardsVersionId(version: String) {
        UserDefaults.standard.set(version, forKey: key)
    }
}
