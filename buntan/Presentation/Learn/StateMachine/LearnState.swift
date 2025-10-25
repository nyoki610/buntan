//
//  LearnState.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/18.
//

import Foundation

enum LearnState: Hashable {
    case answering(LearnCard, FourChoiceOptions)
    case showingFeedbackAnimation(ResultType)
    case reviewing(ResultType)
    case complete

    enum ResultType: Hashable {
        case correct
        case incorrect
    }
    
    func canTransition(to nextState: LearnState) -> Bool {
        switch self {
        case .answering:
            switch nextState {
            case .showingFeedbackAnimation:
                return true
            default:
                return false
            }
            
        case let .showingFeedbackAnimation(resultType):
            switch nextState {
            case .reviewing(resultType):
                return true
            default:
                return false
            }
            
        case .reviewing:
            switch nextState {
            case .answering, .complete:
                return true
            default:
                return false
            }
            
        case .complete:
            return false
        }
    }
}
