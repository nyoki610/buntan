//
//  BuntanAPIClient.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/09.
//

import Foundation

struct BuntanAPIClient {
    
    let config: Config
    
    struct Config {
        let baseURL: URL
        let apiKey: String
    }
    
    func request<Component: BuntanAPIComponent>(for component: Component) async throws -> Component.Response {
        
        let request = makeURLRequest(from: component)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw BuntanAPIError.invalidResponse
        }
        
        if let error = BuntanAPIError(from: data, and: httpResponse, for: config.baseURL) {
            throw error
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(Component.Response.self, from: data)
        } catch {
            throw BuntanAPIError.notDecodedResponse(data, httpResponse)
        }
    }
    
    private func makeURLRequest(from component: some BuntanAPIComponent) -> URLRequest {
        var urlRequest = URLRequest(url: config.baseURL.appendingPathComponent(component.path).appending(queryItems: component.queryItems))
        urlRequest.httpMethod = component.httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(config.apiKey, forHTTPHeaderField: "x-api-key")
        
        if let body = component.body {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        return urlRequest
    }
}
