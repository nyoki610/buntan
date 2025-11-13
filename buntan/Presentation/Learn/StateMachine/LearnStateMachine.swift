//
//  LearnStateMachine.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/18.
//

import Foundation

class LearnStateMachine {
    typealias ResultType = LearnState.ResultType
    
    struct LearnResult {
        var correctCardsIds: Set<String> = []
        var incorrectCardsIds: Set<String> = []
    }
    
    enum Action {
        case submitAnswer(ResultType)
        case completeAnimation(ResultType)
        case finishReview
    }
    
    private(set) var current: LearnState = .initial
    private(set) var currentIndex: Int = 0
    private(set) var result = LearnResult()
    private let cards: [LearnCard]
    private var topCard: LearnCard? {
        guard cards.indices.contains(currentIndex) else {
            return nil
        }
        return cards[currentIndex]
    }
    
    init(cards: [LearnCard]) {
        self.cards = cards
        if let topCard = topCard {
            try? transition(to: .answering(topCard))
        }
    }
    
    func dispatch(_ action: Action) throws {
        switch action {
        case let .submitAnswer(resultType):
            guard let topCard = topCard else {
                throw Error.topCardNotExist
            }
            saveResult(cardId: topCard.id, resultType: resultType)
            try transition(to: .showingFeedbackAnimation(resultType))
            
        case let .completeAnimation(result):
            try transition(to: .reviewing(result))
            
        case .finishReview:
            currentIndex += 1
            guard let nextCard = topCard else {
                try transition(to: .complete)
                return
            }
            try transition(to: .answering(nextCard))
        }
    }
    
    private func transition(to newState: LearnState) throws {
        guard current.canTransition(to: newState) else {
            throw Error.invalidTransitionTarget
        }
        current = newState
    }
    
    private func saveResult(cardId: String, resultType: ResultType) {
        let keyPath: WritableKeyPath<LearnResult, Set<String>> = {
            switch resultType {
            case .correct: return \.correctCardsIds
            case .incorrect: return \.incorrectCardsIds
            }
        }()
        result[keyPath: keyPath].insert(cardId)
    }
    
    private enum Error: Swift.Error {
        case invalidTransitionTarget
        case topCardNotExist
    }
}
