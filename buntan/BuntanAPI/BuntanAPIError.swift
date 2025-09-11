//
//  BuntanAPIError.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/09.
//

import Foundation

enum BuntanAPIError: Error {
    
    case failedToCreateAPIClient
    case invalidResponse
    case notDecodedResponse(Data, HTTPURLResponse)
    case notHandledResponse(Data, HTTPURLResponse)
    
    init?(from data: Data, and response: HTTPURLResponse, for url: URL) {
        switch response.statusCode {
        case 0 ..< 400:
            return nil
            
        // TODO: implement more detailed cases
            
        default:
            self = .notHandledResponse(data, response)
        }
    }
}
