//
//  BookListViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import Foundation

@MainActor
@Observable
final class BookListViewViewModel: ViewModel {
    
    struct Argument {
        var navigator: BookNavigator
        var userInput: BookUserInput
    }
    
    struct Dependency {
        var bookService: any BookServiceProtocol = BookService()
    }
    
    struct State {
        var books: [Book]
    }
    
    struct BindingState {
        var showDetail: Bool = false
    }
    
    enum Action {
        case detailButtonTapped
        case bookButtonTapped(Book)
    }
    
    var argument: Argument
    @ObservationIgnored let dependency: Dependency
    private(set) var state: State
    var binding = BindingState()
    private(set) var error: Error?
    
    init(argument: Argument, books: [Book], dependency: Dependency = .init()) {
        self.argument = argument
        self.dependency = dependency
        self.state = .init(books: books)
    }
    
    func send(_ action: Action) {
        switch action {
        case .detailButtonTapped:
            binding.showDetail = true
        case let .bookButtonTapped(book):
            select(book: book)
        }
    }
    
    private func showDetail() {
        binding.showDetail = true
    }
    
    private func select(book: Book) {
        argument.userInput.selectedBookConfig = book.config
        argument.navigator.push(.sectionList(book))
    }
}
