//
//  MovieRemoteDataSource.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

final class MovieRemoteDataSource: MovieRemoteDataSourceProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMovies(category: MovieCategory) async throws -> MoviesDBRootDTO<[Movie]> {
        let endpoint = APIEndpoint.movies(category: category.endpoint)
        return try await networkService.fetch(endpoint: endpoint)
    }
}
