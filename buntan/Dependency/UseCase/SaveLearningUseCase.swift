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
    func execute(
        learnCards: [LearnCard],
        correctCardsIds: Set<String>,
        incorrectCardsIds: Set<String>,
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
    
    // MARK: - LearnView Refactor Middle Layer @25/10/25
    func execute(
        learnCards: [LearnCard],
        correctCardsIds: Set<String>,
        incorrectCardsIds: Set<String>,
        category: BookCategory
    ) throws {
        let cards: [Card] = try dependency.realmRepository.fetchAll()
        let cardIdToIndex = Dictionary(
            uniqueKeysWithValues: cards.map { ($0.id, $0) }
        )
        let savedCards: [Card] = try learnCards.map { learnCard in
            guard let card = cardIdToIndex[learnCard.id] else {
                throw Error.failedToConvertLearnCardToCard
            }
            return card
        }
        var completedIndices = Set<Int>()
        var learningIndices = Set<Int>()
        for (index, learnCard) in learnCards.enumerated() {
            if correctCardsIds.contains(learnCard.id) {
                completedIndices.insert(index)
            } else if incorrectCardsIds.contains(learnCard.id) {
                learningIndices.insert(index)
            } else {
                throw Error.failedToConvertIdToIndex
            }
        }
        try execute(
            cards: savedCards,
            learningIndices: learningIndices,
            completedIndices: completedIndices,
            category: category
        )
    }
    
    enum Error: Swift.Error {
        case failedToConvertLearnCardToCard
        case failedToConvertIdToIndex
    }
}
