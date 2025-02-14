//
//  NetworkManager.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation

final class NetworkManager: NetworkService {
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    private let networkMonitor: NetworkMonitorContract

    
    init(
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = .init(),
        networkMonitor: NetworkMonitorContract = NetworkMonitor.shared
    ) {
        self.session = session
        self.decoder = decoder
        self.networkMonitor = networkMonitor

        configureDecoder()
    }
    
    func fetch<T: Decodable>(endpoint: APIEndpointContract) async throws -> T {
        guard networkMonitor.status == .connected else {
            ErrorManager.shared.show(.offline)
            throw AppError.offline
        }
        
        guard let urlRequest = endpoint.urlRequest else {
            throw AppError.badURL
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown(message: "Invalid response type")
            }
            try httpResponse.validateStatusCode()
            
            return try decode(data)
            
        } catch let error as URLError {
            // Map URLSession errors to AppError
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw AppError.offline
            default:
                throw AppError.unknown(message: error.localizedDescription)
            }
        } catch let error as AppError {
            throw error // Re-throw predefined errors
        } catch {
            throw AppError.unknown(message: error.localizedDescription)
        }
    }
}

extension NetworkManager {
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            // Add context to decoding errors for debugging
            print(decodingError)
            throw AppError.decodingFailed
            
        }
    }
    
    private func configureDecoder() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601 
    }
    
}
