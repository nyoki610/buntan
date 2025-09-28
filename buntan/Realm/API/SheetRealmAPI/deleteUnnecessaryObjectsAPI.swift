import Foundation


extension SheetRealmAPI {
    
    static func deleteUnnecessaryObjects() -> Bool {
        
        let repository = RealmRepository()
        guard let sheets: [Sheet] = try? repository.fetchAll() else { return false }
        
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
        
        let repository = RealmRepository()
        guard let allIds = try? repository.getAllIds(of: type) else {
            return false
        }

        let unnecessaryObjectIds = allIds.subtracting(necessaryObjectIds)

        do {
            try repository.deleteObjects(by: unnecessaryObjectIds, of: type)
        } catch {
            return false
        }
        return true
    }
}
