import Foundation


class _LearnSelectViewViewModel: ObservableObject {
    
    @Published var cardsContainer: CardsContainer
    @Published var isFetchingUpdatedBook: Bool = false
    private var shouldCallOnAppearAction: Bool = false
    
    init(cardsContainer: CardsContainer) {
        self.cardsContainer = cardsContainer
    }
    
    internal func onAppearAction(userInput: BookUserInput) {
        if shouldCallOnAppearAction {
            updateCardsContainer(userInput: userInput)
        } else {
            shouldCallOnAppearAction = true
        }
    }
    
    internal func updateCardsContainer(userInput: BookUserInput) {
        
        guard let updatedCardsContainer = CardsContainer(userInput: userInput) else { return }
        
        cardsContainer = updatedCardsContainer
    }
}
