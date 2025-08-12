# ViewModel Structure

## Overview

1. Define each protocol
   - 〇〇ViewModelDependency
   - 〇〇ViewModelInput
   - 〇〇ViewModelOutput
   - 〇〇ViewModelActionBinding etc...

2. Create 〇〇ViewModelProtocol that conforms to all necessary protocols and requires input・output as properties
    ```Swift
    protocol 〇〇ViewModelProtocol: 〇〇ViewModelDependency, 〇〇ViewModelInput, 〇〇ViewModelOutput, 〇〇ViewModelActionBinding {
        var input: 〇〇ViewModelInput { get }
        var output: 〇〇ViewModelOutput { get }
    }
    ```

3. Create ViewModels for both Implementation and Mock

## View and ViewModel Action Integration
The following protocol requires a ViewModel to have necessary properties to receive actions from the View and bind them to ViewModel functions.
```Swift
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
```

1. Define an enum 〇〇ViewModelAction that enumerates all actions the ViewModel receives from the View
    ```Swift
    enum 〇〇ViewModelAction {
        case 〇〇ButtonTapped
    }
    ```
2. Define a protocol 〇〇ViewModelActionBinding that conforms to ViewModelActionBinding and requires all functions called in response to View actions.
    ```Swift
    protocol 〇〇ViewModelActionBinding: ViewModelActionBinding where Action == 〇〇ViewModelAction {
        func someFunc()
    }
    ```
3. Define the implementation of `bindInputs()` and call it in the ViewModel's initializer to bind action enums to their corresponding functions.
    ```Swift
    internal func bindInputs() {
        actionSubject
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .〇〇ButtonTapped:
                    self.someFunc()
                }
            }
            .store(in: &cancellables)
    }
    ```

## How to Use ViewModel in View
- Define viewModel as a property
    ```Swift
    struct 〇〇View<ViewModel: 〇〇ViewViewModelProtocol>: View {
    
        @StateObject private var viewModel: ViewModel
    
        init(viewModel: ViewModel) {
            self._viewModel = StateObject(wrappedValue: viewModel)
        }
    }
    ```
- Use output properties
    ```Swift
    viewModel.output.property
    ```
- Send actions
    ```Swift
    viewModel.send(.〇〇ButtonTapped)
    ```
