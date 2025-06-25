import Foundation


final class TypeLearnManager: BookLearnManager {
    
    @Published var isKeyboardActive: Bool = false
    
    init(cards: [Card], options: [[Option]], shouldShuffle: Bool, isKeyboardActive: Bool) {
        
        let indices = Array(0..<cards.count).shuffled()

        let cards = shouldShuffle ? indices.map { cards[$0] } : cards
        let options = shouldShuffle ? indices.map { options[$0] } : options
        
        self.isKeyboardActive = isKeyboardActive
        
        super.init(cards: cards, options: options, nonShuffledCards: cards, nonShuffledOptions: options)
    }
}
