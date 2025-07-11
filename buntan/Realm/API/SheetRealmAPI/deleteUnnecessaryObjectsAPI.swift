import Foundation


extension SheetRealmAPI {
    
    static func deleteUnnecessaryObjects() -> Bool {
        
        guard let sheets = SheetRealmCruds.getAllSheets() else { return false }
        
        let necessaryCardIds = Set(sheets.flatMap { $0.cardList.map { $0.id } })
        let necessaryInfoIds = Set(sheets.flatMap { $0.cardList.flatMap { $0.infoList.map { $0.id } } })
        
        guard deleteUnnecessaryObject(
            of: RealmCard.self,
            necessaryObjectIds: necessaryCardIds
        ) else { return false }
        
        guard deleteUnnecessaryObject(
            of: RealmInfo.self,
            necessaryObjectIds: necessaryInfoIds
        ) else { return false }
        
        return true
    }
    
    private static func deleteUnnecessaryObject<T: IdentifiableRealmObject>(
        of type: T.Type,
        necessaryObjectIds: Set<String>
    ) -> Bool {
        
        guard let allIds = SheetRealmCruds.getAllIds(of: type) else { return false }
        
        let unnecessaryObjectIds = allIds.subtracting(necessaryObjectIds)

        return SheetRealmCruds
            .deleteUnnecessaryObjects(
                of: type,
                unnecessaryIds: unnecessaryObjectIds
            )
    }
}
