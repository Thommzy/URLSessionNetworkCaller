// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

open class URLSessionNetworkCaller<T: Codable> {
    private var baseURL: String
    private var urlPath: String
    private var method: Method
    private var type: T.Type
    private var parameters: [String: Any]? = nil
    
    public init(
        baseURL: String,
        urlPath: String,
        method: Method,
        type: T.Type,
        parameter: [String: Any]?
    ) {
        self.baseURL = baseURL
        self.urlPath = urlPath
        self.method = method
        self.type = type
        self.parameters = parameter
    }
    
    public func makeNetworkRequest() -> AnyPublisher<T, Error>{
        ApiClient.shared.makeRequest(
            baseURL: baseURL,
            urlPath: urlPath,
            method: method,
            type: T.self,
            parameters: parameters
        )
    }
}
