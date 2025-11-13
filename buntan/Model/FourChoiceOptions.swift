//
//  FourChoiceOptions.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import Foundation

struct FourChoiceOptions: Hashable {
    let options: [Option]
    
    init(
        first: Option,
        second: Option,
        third: Option,
        fourth: Option
    ) {
        self.options = [first, second, third, fourth].shuffled()
    }
}
