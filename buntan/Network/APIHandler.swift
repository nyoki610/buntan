import Foundation

enum APIHandler {
    
    enum Method: String {
        case get = "GET"
    }
    
    enum APIError: Error {
        case invalidConfig
        case invalidURL
        case invalidResponse
        case invalidJSON
        case networkError(Error)

        var localizedDescription: String {
            switch self {
            case .invalidConfig: return "API Key or Base URL is not set."
            case .invalidURL: return "Invalid URL"
            case .invalidResponse: return "Invalid response status code"
            case .invalidJSON: return "Invalid JSON format"
            case .networkError(let error): return "API call failed: \(error.localizedDescription)"
            }
        }
    }
    
    static func callAPI(path: String, method: Method) async -> [String: Any]? {
        
        do {
            let request = try createRequest(path: path, method: method)
            return try await performRequest(request)
            
        } catch {
            print("API call failed: \(error)")
            if let apiError = error as? APIError {
                print("API Error type: \(apiError)")
            }
            return nil
        }
    }
    
    private static func createRequest(path: String, method: Method) throws -> URLRequest {

        guard let apiKey = AppConfig.apiKey,
              let baseURL = AppConfig.baseURL else {
            throw APIError.invalidConfig
        }
        let apiURL = baseURL + path
        
        guard let url = URL(string: apiURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        return request
    }
    
    private static func performRequest(_ request: URLRequest) async throws -> [String: Any] {

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return jsonDict ?? [:]

        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context)")
            throw APIError.invalidJSON

        } catch let DecodingError.keyNotFound(key, context) {
            print("Key not found: \(key), context: \(context.debugDescription)")
            print("Coding path: \(context.codingPath)")
            throw APIError.invalidJSON
        
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch: \(type), context: \(context.debugDescription)")
            print("Coding path: \(context.codingPath)")
            throw APIError.invalidJSON
        
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value not found: \(value), context: \(context.debugDescription)")
            print("Coding path: \(context.codingPath)")
            throw APIError.invalidJSON
        
        } catch {
            print("Other error: \(error)")
            throw APIError.networkError(error)
        }
    }
}
