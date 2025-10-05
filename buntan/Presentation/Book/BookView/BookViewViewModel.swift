//
//  BookViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import Foundation

@MainActor
@Observable
final class BookViewViewModel: ViewModel {
    typealias BindingState = Void
    
    struct Argument {
        var navigator: BookNavigator
        var userInput: BookUserInput
    }
    
    struct Dependency {
        var learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()
        var bookService: any BookServiceProtocol = BookService()
    }
    
    struct State {
        var todaysWordCount: Int?
        var variableValue: Double {
            guard let count = todaysWordCount else { return 0.0 }
            switch count {
            case ProgressBarThreshold.full...: return 1.0
            case ProgressBarThreshold.half...: return 0.5
            case ProgressBarThreshold.partial...: return 0.3
            default: return 0.0
            }
        }
        
        private enum ProgressBarThreshold {
            static let full = 1000
            static let half = 100
            static let partial = 10
        }
    }
    
    enum Action {
        case task
        case bookCategoryButtonTapped(grade: EikenGrade, category: BookCategory)
    }
    
    var argument: Argument
    @ObservationIgnored let dependency: Dependency
    private(set) var state = State()
    private(set) var error: Error?
    
    init(argument: Argument, dependency: Dependency = .init()) {
        self.argument = argument
        self.dependency = dependency
    }
    
    func send(_ action: Action) {
        do {
            switch action {
            case .task:
                try task()
            case let .bookCategoryButtonTapped(grade, category):
                try selectBookCategory(grade: grade, bookCategory: category)
            }
        } catch {
            self.error = error
        }
    }
    
    private func task() throws {
        state.todaysWordCount = try dependency.learnRecordService.getTodaysWordCount()
    }
    
    private func selectBookCategory(grade: EikenGrade, bookCategory: BookCategory) throws {
        argument.userInput.selectedGrade = grade
        argument.userInput.selectedBookCategory = bookCategory
        let bookList = try dependency.bookService.getBooks(for: grade, category: bookCategory)
        argument.navigator.push(.bookList(bookList))
    }
}
