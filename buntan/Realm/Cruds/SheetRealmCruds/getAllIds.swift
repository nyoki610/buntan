import Foundation


extension SheetRealmCruds {
    
    static func getAllIds<T: IdentifiableRealmObject>(
        of type: T.Type
    ) -> Set<String>? {
        
        guard let realm = tryRealm(caller: "getAllIds") else { return nil }
        let objects = realm.objects(type)
        return Set(objects.map { $0.id.stringValue })
    }
}
