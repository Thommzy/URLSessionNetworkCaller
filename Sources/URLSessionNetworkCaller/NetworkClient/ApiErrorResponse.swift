//
//  File.swift
//  
//
//  Created by Timothy Obeisun on 7/6/24.
//

import Foundation

enum ApiParseErrors: LocalizedError {
    case invalidDateFormat
    case invalidMemoryType
    case errorDecoding
    case unknownError
    case dataNotFound
    case serverOffline
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidDateFormat:
            return "Invalid date format"
        case .invalidMemoryType:
            return "Invalid memory type"
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Error is Unknown"
        case .dataNotFound:
            return "Data not found"
        case .serverOffline:
            return "Service unavailable at the moment, please try again later"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
