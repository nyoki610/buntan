//
//  CheckConfiguration.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/04.
//

import Foundation

struct CheckConfiguration {
    let totalCount: Int
    var highFrequencyCount: Int
    var mediumFrequencyCount: Int
    
    var lowFrequencyCount: Int {
        totalCount - highFrequencyCount - mediumFrequencyCount
    }
}

extension EikenGrade {
    var questionCount: Int {
        switch self {
        case .first: return 22
        case .preFirst: return 18
        }
    }
    
    var checkConfig: CheckConfiguration {
        let config = {
            switch self {
            case .first:
                return CheckConfiguration(
                    totalCount: questionCount,
                    highFrequencyCount: 9,
                    mediumFrequencyCount: 7
                )
            case .preFirst:
                return CheckConfiguration(
                    totalCount: questionCount,
                    highFrequencyCount: 8,
                    mediumFrequencyCount: 6
                )
            }
        }()
        return addRandomNoise(to: config)
    }
    
    private func addRandomNoise(to config: CheckConfiguration) -> CheckConfiguration {
        let randomNoise: () -> Int = { [-1, 0, 1].randomElement() ?? 0 }
        var updatedConfig = config
        updatedConfig.highFrequencyCount += randomNoise()
        updatedConfig.mediumFrequencyCount += randomNoise()
        return updatedConfig
    }
}
