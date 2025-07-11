import Foundation
import RealmSwift


protocol RealmConvertable {
    
    associatedtype RealmObjectType: Object
    func convertToRealm() -> RealmObjectType
}
