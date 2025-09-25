import Foundation


protocol CheckLearnViewViewModelProtocol: BaseLearnViewViewModel, ObservableObject, AnyObject {
    var checkRecordUseCase: any CheckRecordUseCaseProtocol { get }
}
