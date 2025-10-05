//
//  SectionListViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import Foundation

@MainActor
@Observable
final class SectionListViewViewModel: ViewModel {
    typealias BindingState = Void
    
    struct Argument {
        var navigator: BookNavigator
        var userInput: BookUserInput
    }
    
    struct Dependency {
        var bookService: any BookServiceProtocol = BookService()
    }
    
    struct State {
        var book: Book?
    }
    
    enum Action {
        case task
        case sectionButtonTapped(Section)
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
            case let .sectionButtonTapped(section):
                try select(section: section)
            }
        } catch {
            self.error = error
        }
    }
    
    private func task() throws {
        let grade = try argument.userInput.require(\.selectedGrade)
        let category = try argument.userInput.require(\.selectedBookCategory)
        let config = try argument.userInput.require(\.selectedBookConfig)
        state.book = try dependency.bookService.getBook(
            for: grade,
            category: category,
            config: config
        )
    }
    
    private func select(section: Section) throws {
        argument.userInput.selectedSectionTitle = section.title
        let category = try argument.userInput.require(\.selectedBookCategory)
        let cardsContainer = CardsContainer(
            cards: section.cards,
            bookCategory: category
        )
        argument.navigator.push(.learnSelect(cardsContainer))
    }
}
