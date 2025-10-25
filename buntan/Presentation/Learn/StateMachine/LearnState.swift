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
    case complete([LearnCard], LearnStateMachine.LearnResult)
    case interrupted([LearnCard], LearnStateMachine.LearnResult)

    enum ResultType: Hashable {
        case correct
        case incorrect
    }
    
    func canTransition(to nextState: LearnState) -> Bool {
        switch self {
        case .answering:
            switch nextState {
            case .showingFeedbackAnimation, .interrupted:
                return true
            default:
                return false
            }
            
        case let .showingFeedbackAnimation(resultType):
            switch nextState {
            case .reviewing(resultType), .interrupted:
                return true
            default:
                return false
            }
            
        case .reviewing:
            switch nextState {
            case .answering, .complete, .interrupted:
                return true
            default:
                return false
            }
            
        case .complete:
            switch nextState {
            case .interrupted:
                return true
            default:
                return false
            }
        
        case .interrupted:
            return false
        }
    }
}
