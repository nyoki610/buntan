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
    
    private(set) var current: LearnState
    private(set) var currentIndex: Int = 0
    private(set) var result = LearnResult()
    private let cards: [LearnCard]
    private var currentCard: LearnCard? {
        guard cards.indices.contains(currentIndex) else {
            return nil
        }
        return cards[currentIndex]
    }
    private let options: [FourChoiceOptions]
    private var currentOption: FourChoiceOptions? {
        guard options.indices.contains(currentIndex) else {
            return nil
        }
        return options[currentIndex]
    }
    
    init(
        cards: [LearnCard],
        options: [FourChoiceOptions],
        initialState: LearnState
    ) {
        self.cards = cards
        self.options = options
        current = initialState
    }
    
    func dispatch(_ action: Action) throws {
        switch action {
        case let .submitAnswer(resultType):
            guard let currentCard = currentCard else {
                throw Error.currentCardNotExist
            }
            saveResult(cardId: currentCard.id, resultType: resultType)
            try transition(to: .showingFeedbackAnimation(resultType))
            
        case let .completeAnimation(result):
            try transition(to: .reviewing(result))
            
        case .finishReview:
            currentIndex += 1
            guard let nextCard = currentCard, let nextOption = currentOption else {
                try transition(to: .complete)
                return
            }
            try transition(to: .answering(nextCard, nextOption))
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
        case currentCardNotExist
    }
}

extension LearnStateMachine {
    struct UIOutput {
        let stateMachine: LearnStateMachine
        private var cardsCount: Int { stateMachine.cards.count }
        private var correctCount: Int { stateMachine.result.correctCardsIds.count }
        private var incorrectCount: Int { stateMachine.result.incorrectCardsIds.count }
        var correctRatio: Double { Double(correctCount) / Double(cardsCount) }
        var incorrectRatio: Double { Double(incorrectCount) / Double(cardsCount) }
        var headerLabel: String { "\(correctCount + incorrectCount) / \(cardsCount)" }
        
        init(stateMachine: LearnStateMachine) {
            self.stateMachine = stateMachine
        }
    }
}
