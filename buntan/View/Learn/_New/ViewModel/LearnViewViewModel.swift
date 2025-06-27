import Foundation


final class BookSelectViewViewModel: BaseSelectViewViewModel, BookLearnViewViewModelProtocol {
    
    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]]
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        super.init(cards: cards, options: options)
    }
}


final class BookSwipeViewViewModel: BaseSwipeViewViewModel, BookLearnViewViewModelProtocol {

    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]]
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        super.init(cards: cards, options: options)
    }
}


final class BookTypeViewViewModel: BaseTypeViewViewModel, BookLearnViewViewModelProtocol {

    internal let nonShuffledCards: [Card]
    internal let nonShuffledOptions: [[Option]]
    
    convenience init(cards: [Card], options: [[Option]], shouldShuffle: Bool) {
        
        let shuffledArrays = CardsShuffler.getShuffledArrays(cards: cards, options: options)
        
        self.init(
            cards: shouldShuffle ? shuffledArrays.shuffledCards : cards,
            options: shouldShuffle ? shuffledArrays.shuffledOptions : options,
            nonShuffledCards: cards,
            nonShuffledOptions: options
        )
    }
    
    init(
        cards: [Card],
        options: [[Option]],
        nonShuffledCards: [Card],
        nonShuffledOptions: [[Option]]
    ) {
        self.nonShuffledCards = nonShuffledCards
        self.nonShuffledOptions = nonShuffledOptions
        super.init(cards: cards, options: options)
    }
}

final class CheckSelectViewViewModel: BaseSelectViewViewModel, CheckLearnViewViewModelProtocol {}
