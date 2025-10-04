import Foundation


protocol CheckLearnViewViewModelProtocol: BaseLearnViewViewModel, ObservableObject, AnyObject {
    var checkRecordService: any CheckRecordServiceProtocol { get }
}
