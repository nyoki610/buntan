import Foundation


final class BookSelectViewViewModel: BaseSelectViewViewModel, BookLearnViewViewModelProtocol {
    
    internal let learnRecordService: any LearnRecordServiceProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordService: learnRecordService
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordService: any LearnRecordServiceProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordService = learnRecordService
        super.init(cards: cards, options: options)
    }
}


final class BookSwipeViewViewModel: BaseSwipeViewViewModel, BookLearnViewViewModelProtocol {

    internal let learnRecordService: any LearnRecordServiceProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordService: learnRecordService
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordService: any LearnRecordServiceProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordService = learnRecordService
        super.init(cards: cards, options: options)
    }
}


final class BookTypeViewViewModel: BaseTypeViewViewModel, BookLearnViewViewModelProtocol {

    internal let learnRecordService: any LearnRecordServiceProtocol
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool, learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options,
            learnRecordService: learnRecordService
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]],
        learnRecordService: any LearnRecordServiceProtocol
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        self.learnRecordService = learnRecordService
        super.init(cards: cards, options: options)
    }
}

final class CheckSelectViewViewModel: BaseSelectViewViewModel, CheckLearnViewViewModelProtocol {
    internal let checkRecordService: any CheckRecordServiceProtocol
    init(
        cards: [Card],
        options: [[Option]],
        checkRecordService: any CheckRecordServiceProtocol = CheckRecordService()
    ) {
        self.checkRecordService = checkRecordService
        super.init(cards: cards, options: options)
    }
}
