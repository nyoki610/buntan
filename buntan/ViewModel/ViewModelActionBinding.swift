import Foundation
import Combine

protocol ViewModelActionBinding {
    associatedtype Action
    var actionSubject: PassthroughSubject<Action, Never> { get }
    var cancellables: Set<AnyCancellable> { get }
    func send(_ action: Action)
    func bindInputs()
}

extension ViewModelActionBinding {
    internal func send(_ action: Action) {
        actionSubject.send(action)
    }
}
