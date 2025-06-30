import Foundation
import RealmSwift

protocol ConveretableRealmObject: Object {
    
    associatedtype AssociatedType
    func convertToNonRealm() -> AssociatedType
}


protocol IdentifiableRealmObject: Object {
    var id: ObjectId { get }
}
