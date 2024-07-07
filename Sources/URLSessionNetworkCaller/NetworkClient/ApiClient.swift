//
//  File.swift
//  
//
//  Created by Timothy Obeisun on 7/6/24.
//

import Foundation
import Combine

struct ApiClient {
    static let shared = ApiClient()
    private init () {}
    
    /// Generic method to make requests
    /// - Parameters:
    ///   - urlPath: The Path to the resource in the back end
    ///   - method: Type of request to be made
    ///   - type: Generic type in consideration
    ///   - parameters: whatever information need to pass to the back End
    /// - Returns: Return type which is of type AnyPublisher
    func makeRequest<T: Codable>(
        baseURL: String,
        urlPath: String,
        method: Method,
        type: T.Type,
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, Error> {
        let urlString = (baseURL + urlPath).replacingOccurrences(of: " ", with: "%20")
        
        guard let url = urlString.asUrl else {
            fatalError("Fatal Error")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .put, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw ApiParseErrors.serverOffline
                }
                return data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}
