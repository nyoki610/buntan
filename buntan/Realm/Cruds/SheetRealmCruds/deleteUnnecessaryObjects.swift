import Foundation


extension SheetRealmCruds {
    
    static func deleteUnnecessaryObjects<T: IdentifiableRealmObject>(
        of type: T.Type,
        unnecessaryIds: Set<String>
    ) -> Bool {
        
        guard let realm = tryRealm(caller: "deleteUnnecessaryObjects") else { return false }
        
        let objectsToDelete = realm
            .objects(type)
            .filter { unnecessaryIds.contains($0.id.stringValue) }
        
        if !objectsToDelete.isEmpty {
            do {
                try realm.write {
                    realm.delete(objectsToDelete)
                }
            } catch {
                print("an error occured while deleting unecessary \(type) Objects: \(error.localizedDescription)")
                return false
            }
        }
        
        return true
    }
}
