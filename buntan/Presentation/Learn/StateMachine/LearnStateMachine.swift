//
//  LearnStateMachine.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/18.
//

import SwiftUI

class LearnStateMachine {
    typealias ResultType = LearnState.ResultType
    typealias LearnResult = LearnState.LearnResult

    enum Action {
        case submitAnswer(ResultType)
        case completeAnimation(ResultType)
        case finishReview
        case interruptLearning
        case shuffleCards
        case revertShuffle
        case backToPrevious
        case backToStart
    }

    private(set) var current: LearnState
    private(set) var currentIndex: Int = 0
    private var result = LearnResult()
    private var cards: [LearnCard]
    private var currentCard: LearnCard? {
        guard cards.indices.contains(currentIndex) else {
            return nil
        }
        return cards[currentIndex]
    }
    private var options: [FourChoiceOptions]
    private var currentOption: FourChoiceOptions? {
        guard options.indices.contains(currentIndex) else {
            return nil
        }
        return options[currentIndex]
    }
    var onStateChanged: ((LearnState) async -> Void)?

    init(
        cards: [LearnCard],
        options: [FourChoiceOptions],
        initialState: LearnState
    ) {
        self.cards = cards
        self.options = options
        current = initialState
    }

    func dispatch(_ action: Action) async throws {
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
            if currentIndex + 1 < cards.count {
                currentIndex += 1
                try transitionToAnswering()
            } else {
                try transition(to: .complete(cards, result))
            }

        case .interruptLearning:
            let cards = Array(cards[0..<currentIndex])
            try transition(to: .interrupted(cards, result))

        case .shuffleCards:
            resetLearning()
            shuffleCards()
            try transitionToAnswering()

        case .revertShuffle:
            resetLearning()
            revertShuffle()
            try transitionToAnswering()

        case .backToPrevious:
            try backToPrevious()
            try transitionToAnswering()

        case .backToStart:
            try backToStart()
            try transitionToAnswering()
        }
        await onStateChanged?(current)
    }

    private func transition(to newState: LearnState) throws {
        guard current.canTransition(to: newState) else {
            throw Error.invalidTransitionTarget(from: current, to: newState)
        }
        current = newState
    }

    private func transitionToAnswering() throws {
        guard let nextCard = currentCard, let nextOption = currentOption else {
            return
        }
        try transition(to: .answering(nextCard, nextOption))
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

    private func resetLearning() {
        currentIndex = 0
        result.correctCardsIds.removeAll()
        result.incorrectCardsIds.removeAll()
    }

    private func shuffleCards() {
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        cards = shuffledArrays.shuffledCards
        options = shuffledArrays.shuffledOptions
    }

    private func revertShuffle() {
        cards = cards.sorted { $0.index < $1.index }
        options = options.sorted { $0.index < $1.index }
    }

    private func backToPrevious() throws {
        guard currentIndex > 0 else { return }
        let previousCardIndex = currentIndex - 1
        guard cards.indices.contains(previousCardIndex) else {
            throw Error.invalidCurrentCardIndex
        }
        let previousCardId = cards[previousCardIndex].id
        result.correctCardsIds.remove(previousCardId)
        result.incorrectCardsIds.remove(previousCardId)
        currentIndex = previousCardIndex
    }

    private func backToStart() throws {
        while currentIndex > 0 {
            try backToPrevious()
        }
    }

    private enum Error: Swift.Error {
        case invalidCurrentCardIndex
        case invalidTransitionTarget(from: LearnState, to: LearnState)
        case currentCardNotExist
    }
}

extension LearnStateMachine {
    struct UIOutput {
        let stateMachine: LearnStateMachine
        private var cardsCount: Int { stateMachine.cards.count }
        private var correctCount: Int { stateMachine.result.correctCardsIds.count }
        private var incorrectCount: Int { stateMachine.result.incorrectCardsIds.count }
        var isInitialState: Bool { cardsCount == 0 }
        var correctRatio: Double { Double(correctCount) / Double(cardsCount) }
        var incorrectRatio: Double { Double(incorrectCount) / Double(cardsCount) }
        var headerLabel: String { "\(correctCount + incorrectCount) / \(cardsCount)" }

        var isAnswering: Bool {
            switch stateMachine.current {
            case .answering:
                return true
            default:
                return false
            }
        }

        init(stateMachine: LearnStateMachine) {
            self.stateMachine = stateMachine
        }
    }
}
