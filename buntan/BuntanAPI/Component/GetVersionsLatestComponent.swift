//
//  GetVersionsLatestComponent.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/09.
//

import Foundation

struct GetVersionsLatestComponent: BuntanAPIComponent {
    
    let httpMethod = HTTPMethod.get
    let path = "/versions/latest"
    let queryItems = [URLQueryItem]()
    let body: EmptyParameter? = nil
    
    struct Response: Decodable, Equatable {
        let latestVersionId: String
        
        enum CodingKeys: String, CodingKey {
            case latestVersionId = "latest_version_id"
        }
    }
}
