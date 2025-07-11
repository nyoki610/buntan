import Foundation


extension SheetRealmCruds {
    
    static func getSheetByGrade(eikenGrade: EikenGrade) -> Sheet? {
        
        guard let realm = tryRealm(caller: "getSheetByGrade") else { return nil }

        guard let realmSheet = realm
            .objects(RealmSheet.self)
            .filter("gradeRawValue == %@", eikenGrade.rawValue)
            .first else { return nil }

        return realmSheet.convertToNonRealm()
    }
}
