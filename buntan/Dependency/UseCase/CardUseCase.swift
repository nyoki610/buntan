//
//  CardUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/28.
//

import Foundation

protocol CardUseCaseProtocol {
    func updateStatus(of cards: [Card], learningIndices: [Int], completedIndices: [Int], category: BookCategory) throws
    func resetStatus(of cards: [Card], category: BookCategory) throws
}

struct CardUseCase {
    
    let repository: any RealmRepositoryProtocol
    let cardService: any CardServiceProtocol
    
    init(
        repository: any RealmRepositoryProtocol = RealmRepository(),
        cardService: any CardServiceProtocol = CardService()
    ) {
        self.repository = repository
        self.cardService = cardService
    }
    
    func updateStatus(
        of cards: [Card],
        learningIndices: [Int],
        completedIndices: [Int],
        category: BookCategory
    ) throws {
        let updatedCards = try cardService.updateStatus(
            of: cards,
            learningIndices: learningIndices,
            completedIndices: completedIndices,
            category: category
        )
        try repository.updateAll(updatedCards)
    }
    
    func resetStatus(of cards: [Card], category: BookCategory) throws {
        let resetCards = cardService.resetStatus(of: cards, category: category)
        try repository.updateAll(resetCards)
    }
}
