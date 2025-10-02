//
//  BookUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/30.
//

import Foundation

protocol BookUseCaseProtocol {
    func getBooks(for grade: EikenGrade, category: BookCategory) throws -> [Book]
    func getBook(for grade: EikenGrade, category: BookCategory, config: BookConfiguration) throws -> Book
}

struct BookUseCase: BookUseCaseProtocol {
    
    enum Error: Swift.Error {
        case bookNotFound
    }
    
    private let sheetRepository: any SheetRepositoryProtocol
    
    init(sheetRepository: any SheetRepositoryProtocol = SheetRepository()) {
        self.sheetRepository = sheetRepository
    }
    
    func getBooks(for grade: EikenGrade, category: BookCategory) throws -> [Book] {
        let cards = try sheetRepository
            .getSheet(for: grade)
            .cardList
        return BookFactory.createBooks(from: cards, category: category)
    }
    
    func getBook(for grade: EikenGrade, category: BookCategory, config: BookConfiguration) throws -> Book {
        let books = try getBooks(for: grade, category: category)
        guard let book = books.first(where: { $0.config == config }) else {
            throw Error.bookNotFound
        }
        return book
    }
}
