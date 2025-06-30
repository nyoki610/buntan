import Foundation


enum CardsShuffler {
    
    static func getShuffledArrays(
        cards: [Card],
        options: [[Option]]
    ) -> (
        shuffledCards: [Card],
        shuffledOptions: [[Option]]
    ) {
        
        let indices = Array(0..<cards.count).shuffled()
        
        let shuffledCards = indices.map { cards[$0] }
        let shuffledOptions = indices.map { options[$0] }
        
        return (shuffledCards, shuffledOptions)
    }
}
