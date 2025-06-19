import Foundation
import RealmSwift

extension RealmService {
    
    func tryRealm() -> Realm? {
        
        guard let realmURL = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask)
            .first?
            .appendingPathComponent("myrealm.realm") else {
            
            print("Error: Failed to find user's Realm file directory.")
            return nil
        }
        
        do {
            let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
            let userRealm = try Realm(configuration: config)
            
            print("Log: Realm file successfully accessed at \(realmURL.path)")
            return userRealm
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchRealmObjects() {
        
        guard let realm = tryRealm() else { return }
        
        let sheets = Array(realm.objects(RealmSheet.self).compactMap { $0.convertToNonRealm() })
        let learnRecords = Array(realm.objects(RealmLearnRecord.self).map { $0.convertToNonRealm() })
        let checkRecords = Array(realm.objects(RealmCheckRecord.self).map { $0.convertToNonRealm() })
        
        self.sheetDict = Dictionary(uniqueKeysWithValues: sheets.map { ($0.grade, $0) })
        self.learnRecords = learnRecords
        self.checkRecords = checkRecords.compactMap { $0 }
        
        print("Log: Realm objects were successfully fetched.")
    }
    
    func synchronizeSheet(_ sheet: Sheet) -> Bool {
        
        guard
            let realm = tryRealm(),
            let objectId = try? ObjectId(string: sheet.id),
            let targetSheet = realm.object(ofType: RealmSheet.self, forPrimaryKey: objectId) else { return false }
        
        do {
            try realm.write {
                targetSheet.cardList = sheet.convertToRealm().cardList
            }
            return true
                
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func synchronizeRecord(learnRecord: LearnRecord? = nil, checkRecord: CheckRecord? = nil) {
        
        guard let realm = tryRealm() else { return }
        
        do {
            try realm.write {
                
                if let learnRecord = learnRecord {
                    realm.add(learnRecord.convertToRealm())
                    self.learnRecords.append(learnRecord)
                }
                
                if let checkRecord = checkRecord {
                    realm.add(checkRecord.convertToRealm())
                    self.checkRecords.append(checkRecord)
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
