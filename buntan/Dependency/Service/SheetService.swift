//
//  SheetService.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

protocol SheetServiceProtocol {
    func syncSheetCards(for grade: EikenGrade, with newCards: [Card]) throws
}

struct SheetService: SheetServiceProtocol {
    
    private let realmRepository: any RealmRepositoryProtocol
    private let sheetRepository: any SheetRepositoryProtocol
    
    init(
        realmRepository: any RealmRepositoryProtocol = RealmRepository(),
        sheetRepository: any SheetRepositoryProtocol = SheetRepository()
    ) {
        self.realmRepository = realmRepository
        self.sheetRepository = sheetRepository
    }
    
    func syncSheetCards(for grade: EikenGrade, with newCards: [Card]) throws {
        try ensureSheetExists(for: grade)
        let sheet = try sheetRepository.getSheet(for: grade)
        let oldCards: [Card] = sheet.cardList
        let updatedNewCards: [Card] = preserveCardStatuses(newCards: newCards, oldCards: oldCards)
        try sheetRepository.updateCardList(of: sheet, with: updatedNewCards)
        try cleanupObsoleteCards(oldCards: oldCards)
    }
    
    private func ensureSheetExists(for grade: EikenGrade) throws {
        let sheets: [Sheet] = try realmRepository.fetchAll()
        let grades: Set<EikenGrade> = Set(sheets.map { $0.grade })
        if !grades.contains(grade) {
            let newSheet = SheetFactory.createNew(from: grade)
            try realmRepository.insert(newSheet)
        }
    }
    
    private func preserveCardStatuses(newCards: [Card], oldCards: [Card]) -> [Card] {
        let oldCardsDict: [String: (Card.CardStatus, Card.CardStatus)] = Dictionary(
            uniqueKeysWithValues: oldCards.map { card in
                (card.word, (card.statusFreq, card.statusPos))
            }
        )
        let updatedNewCards = newCards.map { card in
            var newCard = card
            if let (oldStatusFreq, oldStatusPos) = oldCardsDict[newCard.word] {
                newCard.statusFreq = oldStatusFreq
                newCard.statusPos = oldStatusPos
            }
            return newCard
        }
        return updatedNewCards
    }
    
    private func cleanupObsoleteCards(oldCards: [Card]) throws {
        let unnecessaryCardIds = Set(oldCards.map { $0.id })
        let unnecessaryInfoIds = Set(oldCards.flatMap { $0.infoList.map { $0.id }})
        try realmRepository.deleteObjects(by: unnecessaryCardIds, of: RealmCard.self)
        try realmRepository.deleteObjects(by: unnecessaryInfoIds, of: RealmInfo.self)
    }
}
