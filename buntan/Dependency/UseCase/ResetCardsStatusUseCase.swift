//
//  ResetCardsStatusUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

protocol ResetCardsStatusUseCaseProtocol {
    func execute(of cards: [Card], category: BookCategory) throws
}

struct ResetCardsStatusUseCase {
    
    let realmRepository: any RealmRepositoryProtocol
    let cardService: any CardServiceProtocol
    
    init(
        realmRepository: any RealmRepositoryProtocol = RealmRepository(),
        cardService: any CardServiceProtocol = CardService()
    ) {
        self.realmRepository = realmRepository
        self.cardService = cardService
    }
    
    func execute(of cards: [Card], category: BookCategory) throws {
        let resetCards = cardService.resetStatus(of: cards, category: category)
        try realmRepository.updateAll(resetCards)
    }
}
