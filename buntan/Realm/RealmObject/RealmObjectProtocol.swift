import Foundation
import RealmSwift

protocol ConveretableRealmObject: Object {
    
    associatedtype NonRealmType
    func convertToNonRealm() -> NonRealmType
}
