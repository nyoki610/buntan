import Foundation

protocol _LearnViewProtocol {
    
    associatedtype ManagerType: _LearnManager
    var learnManager: ManagerType { get }
    
    var loadingSharedData: LoadingSharedData { get }
    var alertSharedData: AlertSharedData { get }
    var pathHandler: PathHandler { get }
    var userDefaultHandler: LearnUserDefaultHandler { get }
}

extension _LearnViewProtocol {
    
    /// EnvironmentObject を使用した computedPropert
    /// ------------------------------
    var cards: [Card] { learnManager.cards.map { $0 } }
    var topCardIndex: Int { learnManager.topCardIndex }
    var topCard: Card { topCardIndex < cards.count ?  cards[topCardIndex] : EmptyModel.card }
    
    var rightCardsIndexList: [Int] { learnManager.rightCardsIndexList }
    var leftCardsIndexList: [Int] { learnManager.leftCardsIndexList }
    
    var nextCardExist: Bool { topCardIndex < cards.count - 1 }
    /// ------------------------------
}
