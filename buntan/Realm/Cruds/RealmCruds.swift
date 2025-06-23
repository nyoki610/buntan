import Foundation
import RealmSwift

class RealmCruds {
    
    static func tryRealm() -> Realm? {
        
        let schemaVersion: UInt64 = 1
        
        guard let realmURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
            .first?
            .appendingPathComponent("myrealm.realm") else {
            
            print("Error: Failed to find user's Realm file directory.")
            return nil
        }
        
        do {
            let config = Realm.Configuration(fileURL: realmURL, schemaVersion: schemaVersion)
            let userRealm = try Realm(configuration: config)
            
            print("Log: Realm file successfully accessed at \(realmURL.path)")
            return userRealm
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
