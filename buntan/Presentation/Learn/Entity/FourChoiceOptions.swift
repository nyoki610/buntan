//
//  FourChoiceOptions.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import Foundation

struct FourChoiceOptions: Hashable {
    let index: Int /// Store original card order to enable shuffle restoration functionality
    let options: [Option]
    let correctAnswerId: String
    
    init(
        correctAnswer: Option,
        wrongOption1: Option,
        wrongOption2: Option,
        wrongOption3: Option,
        index: Int
    ) {
        self.correctAnswerId = correctAnswer.id
        self.options = [correctAnswer, wrongOption1, wrongOption2, wrongOption3].shuffled()
        self.index = index
    }
    
    func isCorrect(for optionId: String) -> Bool {
        correctAnswerId == optionId
    }
}
