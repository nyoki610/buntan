import Foundation


extension SheetRealmCruds {
    
    static func deleteUnnecessaryObjects<T: IdentifiableRealmObject>(
        of type: T.Type,
        unnecessaryIds: Set<String>
    ) -> Bool {
        
        guard let realm = tryRealm() else { return false }
        
        let objectsToDelete = realm
            .objects(type)
            .filter { unnecessaryIds.contains($0.id.stringValue) }
        
        do {
            try realm.write {
                print("delete \(objectsToDelete.count) \(type)")
                realm.delete(objectsToDelete)
            }
            print("sucessfully deleted unecessary \(type) Objects")
            return true
        } catch {
            print("an error occured while deleting unecessary \(type) Objects: \(error.localizedDescription)")
            return false
        }
    }
}
