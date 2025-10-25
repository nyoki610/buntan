//
//  FourChoiceOptions.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import Foundation

struct FourChoiceOptions: Hashable {
    let options: [Option]
    let correctAnswerId: String
    
    init(
        correctAnswer: Option,
        wrongOption1: Option,
        wrongOption2: Option,
        wrongOption3: Option
    ) {
        self.correctAnswerId = correctAnswer.id
        self.options = [correctAnswer, wrongOption1, wrongOption2, wrongOption3].shuffled()
    }
    
    func isCorrect(for optionId: String) -> Bool {
        correctAnswerId == optionId
    }
}
