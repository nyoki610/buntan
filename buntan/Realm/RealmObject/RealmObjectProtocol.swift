import Foundation
import RealmSwift

protocol ConveretableRealmObject: Object {
    
    associatedtype _NonRealmType
    func convertToNonRealm() -> _NonRealmType
}
