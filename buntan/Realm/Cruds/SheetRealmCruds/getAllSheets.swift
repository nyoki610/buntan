import Foundation


extension SheetRealmCruds {
    
    static func getAllSheets() -> [Sheet]? {
        
        guard let realm = tryRealm() else { return nil }
        
        let realmSheets = realm.objects(RealmSheet.self)
        
        var sheets: [Sheet] = []
        for realmSheet in realmSheets {
            guard let sheet = realmSheet.convertToNonRealm() else { return nil }
            sheets.append(sheet)
        }

        return sheets
    }
}
