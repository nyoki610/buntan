import Foundation
import RealmSwift

extension RealmService {
    
    func setupBooksList() -> [[Book]]? {
        return Eiken.allCases.compactMap { grade in
            guard let sheet = sheets.first(where: { $0.grade == grade }) else { return nil }
            return BookDesign.allCases.map { $0.book(sheet.cardList) }
        }
    }

    func setupRealmFile() {
        do {
            
            /// read the default Realm file from the app's bundle
            /// get bundle Realm objects
            guard let bundleRealmURL = Bundle.main.url(forResource: "myrealm", withExtension: "realm") else {
                print("Error: Failed to find the bundle Realm file directory.")
                return
            }
            let bundleConfig = Realm.Configuration(fileURL: URL(fileURLWithPath: bundleRealmURL.path),
                                                   readOnly: true,
                                                   schemaVersion: 1)
            let bundleRealm = try Realm(configuration: bundleConfig)
            let bundleSheets = bundleRealm.objects(RealmSheet.self)
            
            /// get user's Realm objects
            
            guard let userRealm = tryRealm() else { return }
            let userSheets = userRealm.objects(RealmSheet.self)
            let userGrades = Set(userSheets.map { $0.grade })
            

            try userRealm.write {
                for realmSheet in bundleSheets {
                    
                    guard let grade = realmSheet.grade else { return }
                    
                    if !userGrades.contains(realmSheet.grade) {
                        let newRealmSheet = RealmSheet()
                        newRealmSheet.gradeRawValue = grade.rawValue
                        newRealmSheet.cardList = realmSheet.cardList
                        
                        userRealm.create(RealmSheet.self, value: newRealmSheet, update: .modified)
                        print("Log: The Sheet of \(grade.rawValue) grade has been added to the user Realm.")
                    } else {
                        print("Log: The Sheet of \(grade.rawValue) grade already exists in the user Realm.")
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
