import Foundation


final class BookSelectViewViewModel: BaseSelectViewViewModel, BookLearnViewViewModelProtocol {
    
    internal let learnRecordUseCase: any LearnRecordUseCaseProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordUseCase: any LearnRecordUseCaseProtocol = LearnRecordUseCase()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordUseCase: learnRecordUseCase
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordUseCase: any LearnRecordUseCaseProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordUseCase = learnRecordUseCase
        super.init(cards: cards, options: options)
    }
}


final class BookSwipeViewViewModel: BaseSwipeViewViewModel, BookLearnViewViewModelProtocol {

    internal let learnRecordUseCase: any LearnRecordUseCaseProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordUseCase: any LearnRecordUseCaseProtocol = LearnRecordUseCase()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordUseCase: learnRecordUseCase
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordUseCase: any LearnRecordUseCaseProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordUseCase = learnRecordUseCase
        super.init(cards: cards, options: options)
    }
}


final class BookTypeViewViewModel: BaseTypeViewViewModel, BookLearnViewViewModelProtocol {

    internal let learnRecordUseCase: any LearnRecordUseCaseProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordUseCase: any LearnRecordUseCaseProtocol = LearnRecordUseCase()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordUseCase: learnRecordUseCase
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordUseCase: any LearnRecordUseCaseProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordUseCase = learnRecordUseCase
        super.init(cards: cards, options: options)
    }
}

final class CheckSelectViewViewModel: BaseSelectViewViewModel, CheckLearnViewViewModelProtocol {}
