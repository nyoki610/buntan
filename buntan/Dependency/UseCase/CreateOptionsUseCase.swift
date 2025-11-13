//
//  CreateOptionsUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/02.
//

import Foundation

struct CreateOptionsUseCase {
    
    enum Error: Swift.Error {
        case error
    }
    
    private let sheetRepository: any SheetRepositoryProtocol
    
    init(sheetRepository: any SheetRepositoryProtocol = SheetRepository()) {
        self.sheetRepository = sheetRepository
    }
    
    func execute(
        from cards: [Card],
        for grade: EikenGrade,
        withFifthOption: Bool
    ) throws -> [[Option]] {
        
        let targetGradeCards = try sheetRepository
            .getSheet(for: grade)
            .cardList
        let optionsByPos: [Pos: [Option]] = setupOptionsDict(for: targetGradeCards)
        return try cards.map { card in
            guard let optionsRef = optionsByPos[card.pos] else { throw Error.error }
            return createOptions(for: card, ref: optionsRef, withFifthOption: withFifthOption)
        }
    }
    
    private func setupOptionsDict(for cards: [Card]) -> [Pos: [Option]] {
        var optionsByPos: [Pos: [Option]] = [:]
        for card in cards {
            optionsByPos[card.pos, default: []].append(card.convertToOption())
        }
        return optionsByPos
    }
    
    private func createOptions(for card: Card, ref: [Option], withFifthOption: Bool) -> [Option] {
        let filteredRef = ref.filter { $0.word != card.word }
        let randomOptions = filteredRef.shuffled().prefix(withFifthOption ? 4 : 3)
        return ([card.convertToOption()] + Array(randomOptions)).shuffled()
    }
}
