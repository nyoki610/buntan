//
//  LearnFourChoicesViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import Foundation
import Combine

@MainActor
@Observable
final class LearnFourChoicesViewViewModel: ViewModel {
    typealias BindingState = Void
    
    struct Argument {
        var navigator: BookNavigator
        var userInput: BookUserInput
    }
    var userDefaultHandler = LearnUserDefaultHandler.shared
    
    struct Dependency {
        let saveLearningUseCase: SaveLearningUseCaseProtocol
        
        init(saveLearningUseCase: any SaveLearningUseCaseProtocol = SaveLearningUseCase()) {
            self.saveLearningUseCase = saveLearningUseCase
        }
    }
    
    struct State {
        var currentCard: LearnCard
        var currentOption: FourChoiceOptions
        var showSetting: Bool = true
        var selectedOptionId: String = ""
        var optionStatus: LearnOptionView.Status = .answering
        let avSpeaker = AVSpeaker()
        var isReadingOut: Bool = false
    }
    
    enum Action {
        case toggleShowSetting
        case selectOption(optionId: String)
        case didXmarkButtonTapped
        case didShuffleButtonTapped
        case didBackButtonTapped
        case didBackToStartButtonTapped
        case didReadOutButtonTapped
        case didPassButtonTapped
    }
    
    var argument: Argument
    @ObservationIgnored let dependency: Dependency
    private(set) var state: State
    private(set) var error: Error?
    private let stateMachine: LearnStateMachine
    var uiOutput: LearnStateMachine.UIOutput { .init(stateMachine: stateMachine) }
    
    init(
        state: State,
        stateMachine: LearnStateMachine,
        argument: Argument,
        dependency: Dependency
    ) {
        self.state = state
        self.argument = argument
        self.dependency = dependency
        self.stateMachine = stateMachine
        self.stateMachine.onStateChanged = { [weak self] current in
            await self?.syncState(with: current)
        }
    }

    func send(_ action: Action) async{
        do {
            switch action {
            case .toggleShowSetting:
                state.showSetting.toggle()
                
            case .selectOption(let optionId):
                try await submitAnswer(selectedOptionId: optionId)
                
            case .didXmarkButtonTapped:
                try await stateMachine.dispatch(.interruptLearning)
                
            case .didShuffleButtonTapped:
                confirmShuffle()
                
            case .didBackButtonTapped:
                try await stateMachine.dispatch(.backToPrevious)
                
            case .didBackToStartButtonTapped:
                try await stateMachine.dispatch(.backToStart)
                
            case .didReadOutButtonTapped:
                await readOutCurrentCard()
                
            case .didPassButtonTapped:
                try await submitAnswer(selectedOptionId: "")
            }
        } catch {
            self.error = error
        }
    }
    
    private func syncState(with current: LearnState) async {
        do {
            switch current {                
            case .answering(let card, let option):
                state.currentCard = card
                state.currentOption = option
                state.optionStatus = .answering
                
            case .showingFeedbackAnimation(let result):
                await showFeedBackAnimation(for: result)
                try await stateMachine.dispatch(.completeAnimation(result))
                
            case .reviewing:
                try await stateMachine.dispatch(.finishReview)
                
            case .complete(let cards, let result):
                try await finishLearning(
                    cards: cards,
                    result: result,
                    destination: .learnResult(learnedCardCount: cards.count)
                )
                
            case .interrupted(let cards, let result):
                try await finishLearning(
                    cards: cards,
                    result: result,
                    destination: .learnSelect
                )
            }
        } catch {
            self.error = error
        }
    }
    
    private func submitAnswer(selectedOptionId: String) async throws {
        state.selectedOptionId = selectedOptionId
        let isCorrect = state.currentOption.isCorrect(for: selectedOptionId)
        let result: LearnStateMachine.ResultType = isCorrect ? .correct : .incorrect
        try await stateMachine.dispatch(.submitAnswer(result))
    }
    
    private func showFeedBackAnimation(for result: LearnStateMachine.ResultType) async {
        state.optionStatus = .showingFeedBack(
            answerId: state.currentOption.correctAnswerId,
            selectedId: state.selectedOptionId
        )
        try? await Task.sleep(nanoseconds: result == .correct ? 0_300_000_000 : 1_000_000_000)
    }
    
    private func saveLearningResult(
        cards: [LearnCard],
        result: LearnStateMachine.LearnResult
    ) async throws {
        guard let selectedBookCategory = argument.userInput.selectedBookCategory else { return }
        try dependency.saveLearningUseCase.execute(
            learnCards: cards,
            correctCardsIds: result.correctCardsIds,
            incorrectCardsIds: result.incorrectCardsIds,
            category: selectedBookCategory
        )
    }
    
    private func finishLearning(
        cards: [LearnCard],
        result: LearnStateMachine.LearnResult,
        destination: TransitionDestination
    ) async throws {
        await LoadingManager.shared.startLoading(.save)
        /// ensure loading screen rendering by delaying the next process
        let delay: UInt64 = 100_000_000
        try await Task.sleep(nanoseconds: delay)
        try await saveLearningResult(cards: cards, result: result)
        await LoadingManager.shared.finishLoading()
        transition(to: destination)
    }
    
    private func transition(to destination: TransitionDestination) {
        guard let cardsContainer = CardsContainer(userInput: argument.userInput) else { return }
        switch destination {
        case .learnResult(let learnedCardsCount):
            argument.navigator.push(.learnResult(cardsContainer, learnedCardsCount))
            
        case .learnSelect:
            argument.navigator.pop(to: .sectionList)
            argument.navigator.push(.learnSelect(cardsContainer))
        }
    }
    
    private enum TransitionDestination{
        case learnSelect
        case learnResult(learnedCardCount: Int)
    }
    
    private func confirmShuffle() {
        let title = "現在の進捗はリセットされます\n\(userDefaultHandler.shouldShuffle ? "元に戻" : "シャッフル")しますか？"
        let secondaryButtonLabel = userDefaultHandler.shouldShuffle ? "元に戻す" : "シャッフル"
        let config = AlertManager.SelectiveAlertConfig(
            title: title,
            message: nil,
            secondaryButtonLabel: secondaryButtonLabel,
            secondaryButtonType: .defaultButton,
            secondaryButtonAction: { Task { await self.shuffleCards() }}
        )
        AlertManager.shared.showAlert(type: .selective(config: config))
    }
    
    private func shuffleCards() async {
        do {
            userDefaultHandler.shouldShuffle.toggle()
            if userDefaultHandler.shouldShuffle {
                try await stateMachine.dispatch(.shuffleCards)
            } else {
                try await stateMachine.dispatch(.revertShuffle)
            }
        } catch {
            self.error = error
        }
    }
    
    private func readOutCurrentCard() async {
        state.isReadingOut = true
        await state.avSpeaker.readOutText(text: state.currentCard.word, withDelay: false)
        state.isReadingOut = false
    }
}

@MainActor
enum LearnFourChoicesViewViewModelFactory {
    typealias ViewModel = LearnFourChoicesViewViewModel
    static func create(
        cards: [Card],
        argument: ViewModel.Argument,
        dependency: ViewModel.Dependency = .init()
    ) throws -> ViewModel {
        let learnCards = cards.enumerated().map { index, card in
            LearnCard(from: card, index: index)
        }
        guard let selectedGrade = argument.userInput.selectedGrade else {
            throw Error.gradeNotSelected
        }
        let createFourChoicesOptionsUseCase = CreateFourChoicesOptionsUseCase()
        let options = try createFourChoicesOptionsUseCase.execute(
            from: cards,
            for: selectedGrade
        )
        guard let firstCard = learnCards.first else {
            throw Error.emptyCards
        }
        guard let firstOption = options.first else {
            throw Error.emptyOptions
        }
        let state = ViewModel.State(currentCard: firstCard, currentOption: firstOption)
        let stateMachine = LearnStateMachine(
            cards: learnCards,
            options: options,
            initialState: .answering(firstCard, firstOption)
        )
        return .init(state: state, stateMachine: stateMachine, argument: argument, dependency: dependency)
    }
    
    enum Error: Swift.Error {
        case gradeNotSelected
        case emptyCards
        case emptyOptions
    }
}
