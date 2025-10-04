//
//  CardService.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/28.
//

import Foundation

protocol CardServiceProtocol {
    func getCards(grade: EikenGrade, category: BookCategory, config: BookConfiguration, sectionTitle: String) throws -> [Card]
    func updateStatus(of cards: [Card], learningIndices: [Int], completedIndices: [Int], category: BookCategory) -> [Card]
    func resetStatus(of cards: [Card], category: BookCategory) -> [Card]
}

struct CardService: CardServiceProtocol {
    
    enum Error: Swift.Error {
        case bookNotFound
        case sectionNotFound
    }
    
    func getCards(
        grade: EikenGrade,
        category: BookCategory,
        config: BookConfiguration,
        sectionTitle: String
    ) throws -> [Card] {
        let bookService = BookService()
        let books = try bookService.getBooks(for: grade, category: category)
        guard let book = books.first(where: { $0.config == config }) else {
            throw Error.bookNotFound
        }
        guard let section = book.sections.first(where: { $0.title == sectionTitle }) else {
            throw Error.sectionNotFound
        }
        return section.cards
    }
    
    
    func updateStatus(
        of cards: [Card],
        learningIndices: [Int],
        completedIndices: [Int],
        category: BookCategory
    ) -> [Card] {
        
        let learningIndexSet = Set(learningIndices)
        let completedIndexSet = Set(completedIndices)

        return cards.enumerated().compactMap { (index, card) in
            guard let newStatus = getNewStatus(
                for: index,
                learningIndexSet: learningIndexSet,
                completedIndexSet: completedIndexSet
            ) else { return nil }
            return updateStatus(
                of: card,
                to: newStatus,
                category: category
            )
        }
    }
    
    private func getNewStatus(
        for index: Int,
        learningIndexSet: Set<Int>,
        completedIndexSet: Set<Int>
    ) -> Card.CardStatus? {
        if learningIndexSet.contains(index) {
            return .learning
        } else if completedIndexSet.contains(index) {
            return .completed
        } else {
            return nil
        }
    }
    
    private func updateStatus(
        of card: Card,
        to status: Card.CardStatus,
        category: BookCategory
    ) -> Card {
        var updatedCard = card
        switch category {
        case .freq:
            updatedCard.statusFreq = status
        case .pos:
            updatedCard.statusPos = status
        }
        return updatedCard
    }
    
    func resetStatus(of cards: [Card], category: BookCategory) -> [Card] {
        return cards.map {
            var resetCard = $0
            switch category {
            case .freq:
                resetCard.statusFreq = .notLearned
            case .pos:
                resetCard.statusPos = .notLearned
            }
            return resetCard
        }
    }
}
