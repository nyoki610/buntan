import Foundation

enum VersionUserDefaultHandler {
    
    enum Key: String {
        case usersCardsVersionId
    }

    static func getValue(forKey key: Key) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }

    static func setValue(value: String, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
