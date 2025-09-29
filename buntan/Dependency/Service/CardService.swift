//
//  CardService.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/28.
//

import Foundation

protocol CardServiceProtocol {
    func updateStatus(of cards: [Card], learningIndices: [Int], completedIndices: [Int], category: BookCategory) throws -> [Card]
    func resetStatus(of cards: [Card], category: BookCategory) -> [Card]
}

struct CardService: CardServiceProtocol {
    
    enum Error: Swift.Error {
        case indexNotFound
    }
    
    func updateStatus(
        of cards: [Card],
        learningIndices: [Int],
        completedIndices: [Int],
        category: BookCategory
    ) throws -> [Card] {
        
        let learningIndexSet = Set(learningIndices)
        let completedIndexSet = Set(completedIndices)

        return try cards.enumerated().map { (index, card) in
            let newStatus = try getNewStatus(
                for: index,
                learningIndexSet: learningIndexSet,
                completedIndexSet: completedIndexSet
            )
            return updateStatus(
                of: card,
                to: newStatus,
                category: category
            )
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
    
    private func getNewStatus(
        for index: Int,
        learningIndexSet: Set<Int>,
        completedIndexSet: Set<Int>
    ) throws -> Card.CardStatus {
        if learningIndexSet.contains(index) {
            return .learning
        } else if completedIndexSet.contains(index) {
            return .completed
        } else {
            throw Error.indexNotFound
        }
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
