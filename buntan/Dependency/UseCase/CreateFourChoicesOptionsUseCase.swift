//
//  CreateFourChoicesOptionsUseCase.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/25.
//

import Foundation

protocol CreateFourChoicesOptionUseCaseProtocol {
    func execute(from cards: [Card], for grade: EikenGrade) throws
}

struct CreateFourChoicesOptionsUseCase {
    private let sheetRepository: any SheetRepositoryProtocol
    
    init(sheetRepository: any SheetRepositoryProtocol = SheetRepository()) {
        self.sheetRepository = sheetRepository
    }
    
    enum Error: Swift.Error {
        case candidateOptionNotFound
    }
    
    func execute(
        from cards: [Card],
        for grade: EikenGrade
    ) throws -> [FourChoiceOptions] {
        let targetGradeCards = try sheetRepository
            .getSheet(for: grade)
            .cardList
        let optionsByPos: [Pos: [Option]] = setupOptionsDict(for: targetGradeCards)
        return try cards.enumerated().map { index, card in
            guard let optionsRef = optionsByPos[card.pos] else {
                throw Error.candidateOptionNotFound
            }
            return createOptions(
                for: card,
                ref: optionsRef,
                index: index
            )
        }
    }
    
    private func setupOptionsDict(for cards: [Card]) -> [Pos: [Option]] {
        var optionsByPos: [Pos: [Option]] = [:]
        for card in cards {
            optionsByPos[card.pos, default: []].append(card.convertToOption())
        }
        return optionsByPos
    }
    
    private func createOptions(
        for card: Card,
        ref: [Option],
        index: Int
    ) -> FourChoiceOptions {
        let filteredRef = ref.filter { $0.word != card.word }
        let randomOptions = filteredRef.shuffled().prefix(4)
        return .init(
            correctAnswer: card.convertToOption(),
            wrongOption1: randomOptions[0],
            wrongOption2: randomOptions[1],
            wrongOption3: randomOptions[2],
            index: index
        )
    }
}
