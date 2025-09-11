//
//  BuntanAPIComponent.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/09.
//

import Foundation

protocol BuntanAPIComponent {
    
    associatedtype BodyParameter: Encodable
    
    associatedtype Response: Decodable
    
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var body: BodyParameter? { get }
}

/// Type indicating that there are no parameters to include in the request body
struct EmptyParameter: Encodable {
    public init() {}
}

enum HTTPMethod: String {
    case get = "GET"
}
