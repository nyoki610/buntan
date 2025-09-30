import SwiftUI
import Combine

// -----------------
//  MARK: Ptorocols
// -----------------

// MARK: - Dependency
protocol BookViewViewModelDependency: ObservableObject {
    var navigator: BookNavigator { get set }
    var userInput: BookUserInput { get set }
    var dataService: BookDataServiceProtocol { get set }
}

// MARK: - Input
protocol BookViewViewModelInput {}

// MARK: - Output
protocol BookViewViewModelOutput {
    var todaysWordCount: Int? { get set }
    var variableValue: Double { get }
}

// MARK: - Action
enum BookViewViewModelAction {
    case task
    case bookCategoryButtonTapped(grade: EikenGrade, category: BookCategory)
}

// MARK: - ActionBinding
protocol BookViewViewModelActionBinding: ViewModelActionBinding where Action == BookViewViewModelAction {
    func selectBookCategory(grade: EikenGrade, bookCategory: BookCategory)
}

// MARK: - ViewModelProtocol
protocol BookViewViewModelProtocol: BookViewViewModelDependency, BookViewViewModelInput, BookViewViewModelOutput, BookViewViewModelActionBinding {
    var input: BookViewViewModelInput { get }
    var output: BookViewViewModelOutput { get }
}

// ----------------------
//  MARK: Implementation
// ----------------------

// MARK: - ViewModel Implementation
class BookViewViewModel: ObservableObject, BookViewViewModelProtocol {
    
    public var output: BookViewViewModelOutput { return self }
    public var input: BookViewViewModelInput { return self }

    // MARK: - Dependencies (Protocol Requirements)
    internal var navigator: BookNavigator
    internal var userInput: BookUserInput
    internal var dataService: BookDataServiceProtocol
    internal var learnRecordUseCase: LearnRecordUseCaseProtocol
    
    // MARK: - Constants
    private enum ProgressBarThreshold {
        static let full = 1000
        static let half = 100
        static let partial = 10
    }
    
    // MARK: - Outputs
    @Published internal var todaysWordCount: Int?
    internal var variableValue: Double {
        guard let count = todaysWordCount else { return 0.0 }
        
        switch count {
        case ProgressBarThreshold.full...: return 1.0
        case ProgressBarThreshold.half...: return 0.5
        case ProgressBarThreshold.partial...: return 0.3
        default: return 0.0
        }
    }
    
    // MARK: - ActionBinding (property)
    internal let actionSubject = PassthroughSubject<BookViewViewModelAction, Never>()
    internal var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(
        navigator: BookNavigator,
        userInput: BookUserInput,
        dataService: BookDataServiceProtocol = BookDataService(),
        learnRecordUseCase: LearnRecordUseCaseProtocol = LearnRecordUseCase()
    ) {
        self.navigator = navigator
        self.userInput = userInput
        self.dataService = dataService
        self.learnRecordUseCase = learnRecordUseCase

        bindInputs()
    }
    
    internal func task() {
        self.todaysWordCount = try? learnRecordUseCase.getTodaysWordCount()
    }
    
    // MARK: - ActionBinding (action)
    
    internal func bindInputs() {
        
        actionSubject
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .task:
                    self.task()
                case let .bookCategoryButtonTapped(grade, category):
                    self.selectBookCategory(grade: grade, bookCategory: category)
                }
            }
            .store(in: &cancellables)
    }
    
    internal func selectBookCategory(grade: EikenGrade, bookCategory: BookCategory) {

        userInput.selectedGrade = grade
        userInput.selectedBookCategory = bookCategory
        
        guard let bookList = dataService.getBookList(grade: grade, category: bookCategory) else {
            return
        }
        
        DispatchQueue.main.async {
            self.navigator.push(.bookList(bookList))
        }
    }
}

// MARK: - Data Service Protocol
protocol BookDataServiceProtocol {

    func getBookList(grade: EikenGrade, category: BookCategory) -> [Book]?
}

// MARK: - Data Service Implementation
struct BookDataService: BookDataServiceProtocol {

    func getBookList(grade: EikenGrade, category: BookCategory) -> [Book]? {
        let bookUseCase = BookUseCase()
        return try? bookUseCase.getBooks(for: grade, category: category)
    }
}
