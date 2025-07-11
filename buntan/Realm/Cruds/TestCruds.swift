import Foundation


final class TestCruds: RealmCruds {
    
    static func getAllCardsCount() -> Int? {
        guard let realm = tryRealm(caller: "getAllCardsCount") else { return nil }
        return realm.objects(RealmCard.self).count
    }
    
    static func getAllInfomationsCount() -> Int? {
        guard let realm = tryRealm(caller: "getAllInfomationsCount") else { return nil }
        return realm.objects(RealmInfo.self).count
    }
}
