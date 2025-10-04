//
//  GetCheckCardsUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

protocol GetCheckCardsUseCaseProtocol {
    func execute(for grade: EikenGrade) throws -> [Card]
}

struct GetCheckCardsUseCase: GetCheckCardsUseCaseProtocol {
    
    enum Error: Swift.Error {
        case bookNotFound
    }
    
    func execute(for grade: EikenGrade) throws -> [Card] {
        let bookService = BookService()
        let books = try bookService.getBooks(for: grade, category: .freq)
        let config = grade.checkConfig
        let cards = try FrequencyBookConfiguration.allCases.flatMap {
            let book = try extractBook(for: .frequency($0), from: books)
            return extractCards(from: book, count: getCount(for: $0, from: config))
        }
        return cards.shuffled()
    }
    
    private func extractBook(for config: BookConfiguration, from books: [Book]) throws -> Book {
        guard let book = books.first(where: {$0.config == config}) else {
            throw Error.bookNotFound
        }
        return book
    }
    
    private func extractCards(from book: Book, count: Int) -> [Card] {
        book.sections.flatMap { $0.cards }.randomElements(count)
    }
    
    private func getCount(for freqConfig: FrequencyBookConfiguration, from checkConfig: CheckConfiguration) -> Int {
        switch freqConfig {
        case .freqA: return checkConfig.highFrequencyCount
        case .freqB: return checkConfig.mediumFrequencyCount
        case .freqC: return checkConfig.lowFrequencyCount
        }
    }
}
