//
//  AppError.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation

enum AppError: Error {
    case rateLimitExceeded
    case invalidAPIKey
    case badURL
    case offline
    case decodingFailed
    case serverError(statusCode: Int)
    case clientError(statusCode: Int)
    case emptyData
    case unknown(statusCode: Int? = nil, message: String = "An unknown error occurred.")
    
    
    var errorDescription: String {
        switch self {
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .invalidAPIKey:
            return "Invalid API key. Contact support."
        case .badURL:
            return "Invalid URL."
        case .offline:
            return "The internet connection appears offline."
        case .decodingFailed:
            return "Failed to parse server response."
        case .serverError:
            return "Server error. Try again later."
        case .clientError(let statusCode):
            return clientErrorMessage(for: statusCode)
        case .emptyData:
            return "No data available."
        case .unknown(_, let message):
            return message
        }
    }
    
    private func clientErrorMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 400: return "Bad request."
        case 401: return "Unauthorized. Invalid API key."
        case 404: return "Resource not found."
        case 429: return "Too many requests."
        default: return "Request failed (code \(statusCode))."
        }
    }
}

extension AppError {
    // Helper to attach debugging context
    func with(context: String) -> AppError {
        switch self {
        case .decodingFailed:
            return .unknown(message: "Decoding failed: \(context)")
        default:
            return self
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.rateLimitExceeded, .rateLimitExceeded),
             (.invalidAPIKey, .invalidAPIKey),
             (.badURL, .badURL),
             (.offline, .offline),
             (.decodingFailed, .decodingFailed),
             (.emptyData, .emptyData):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)),
             (.clientError(let lhsCode), .clientError(let rhsCode)):
            return lhsCode == rhsCode
        case (.unknown(let lhsCode, let lhsMsg), .unknown(let rhsCode, let rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

extension HTTPURLResponse {
    func validateStatusCode() throws {
        guard (200...299).contains(statusCode) else {
            switch statusCode {
            case 400...499:
                if statusCode == 401 {
                    throw AppError.invalidAPIKey
                } else if statusCode == 429 {
                    throw AppError.rateLimitExceeded
                } else {
                    throw AppError.clientError(statusCode: statusCode)
                }
            case 500...599:
                throw AppError.serverError(statusCode: statusCode)
            default:
                throw AppError.unknown(statusCode: statusCode, message: "Unexpected HTTP status: \(statusCode)")
            }
        }
    }
}
