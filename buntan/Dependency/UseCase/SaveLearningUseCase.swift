//
//  SaveLearningUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

protocol SaveLearningUseCaseProtocol {
    func execute(
        cards: [Card],
        learningIndices: Set<Int>,
        completedIndices: Set<Int>,
        category: BookCategory
    ) throws
}

struct SaveLearningUseCase: SaveLearningUseCaseProtocol {

    struct Dependency {
        let realmRepository: any RealmRepositoryProtocol = RealmRepository()
        let cardService: any CardServiceProtocol = CardService()
    }

    private let dependency: Dependency
    
    init(dependency: Dependency = .init()) {
        self.dependency = dependency
    }
    
    func execute(
        cards: [Card],
        learningIndices: Set<Int>,
        completedIndices: Set<Int>,
        category: BookCategory
    ) throws {
        try updateStatus(
            of: cards,
            learningIndices: learningIndices,
            completedIndices: completedIndices,
            category: category
        )
        let learnedCardsCount = learningIndices.count + completedIndices.count
        let learnRecord = LearnRecord(
            id: UUID().uuidString,
            date: Date(),
            learnedCardCount: learnedCardsCount
        )
        try dependency.realmRepository.insert(learnRecord)
    }
    
    private func updateStatus(
        of cards: [Card],
        learningIndices: Set<Int>,
        completedIndices: Set<Int>,
        category: BookCategory
    ) throws {
        let updatedCards = dependency.cardService.updateStatus(
            of: cards,
            learningIndices: learningIndices,
            completedIndices: completedIndices,
            category: category
        )
        try dependency.realmRepository.updateAll(updatedCards)
    }
}
