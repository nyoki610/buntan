//
//  GetCardsLatestComponent.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/09.
//

import Foundation

struct GetCardsLatestComponent: BuntanAPIComponent {
    
    let httpMethod = HTTPMethod.get
    let path = "/cards/latest"
    let queryItems = [URLQueryItem]()
    let body: EmptyParameter? = nil
    
    struct Response: Decodable, Equatable {
        let firstGradeCards: [Card]
        let preFirstGradeCards: [Card]
        
        enum CodingKeys: String, CodingKey {
            case firstGradeCards = "first_grade_cards"
            case preFirstGradeCards = "first_pre_grade_cards"
        }
    }
}
