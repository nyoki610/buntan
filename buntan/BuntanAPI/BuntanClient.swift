//
//  BuntanClient.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/11.
//

import Foundation

protocol BuntanClientProtocol {
    
    static func makeAPIClient(apiKey: String, baseURL: String) throws -> BuntanAPIClient
    static func getCardsLatest(config: AppConfigProtocol) async throws -> GetCardsLatestComponent.Response
}

struct BuntanClient: BuntanClientProtocol {
    
    static func makeAPIClient(apiKey: String, baseURL: String) throws -> BuntanAPIClient {
        guard let url = URL(string: baseURL) else {
            throw BuntanAPIError.failedToCreateAPIClient
        }
        let config = BuntanAPIClient.Config(baseURL: url, apiKey: apiKey)
        return BuntanAPIClient(config: config)
    }
    
    static func getCardsLatest(config: AppConfigProtocol) async throws -> GetCardsLatestComponent.Response {
        guard let apiKey = config.apiKey,
              let baseURL = config.baseURL else {
            throw BuntanAPIError.failedToCreateAPIClient
        }
        let apiClient = try makeAPIClient(apiKey: apiKey, baseURL: baseURL)
        let component = GetCardsLatestComponent()
        let response = try await apiClient.request(for: component)
        
        return response
    }
}
