//
//  LearnCard.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import Foundation

struct LearnCard: Hashable {
    let id: String
    let index: Int /// Store original card order to enable shuffle restoration functionality
    let word: String
    let pos: Pos
    let phrase: String
    let meaning: String
    let sentence: String
    let translation: String
    let startPosition: Int
    let endPosition: Int

    init(from card: Card, index: Int) {
        id = card.id
        word = card.word
        pos = card.pos
        phrase = card.phrase
        meaning = card.meaning
        sentence = card.sentence
        translation = card.translation
        startPosition = card.startPosition
        endPosition = card.endPosition
        self.index = index
    }
}
