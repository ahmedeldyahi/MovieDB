//
//  MovieLocalDataSource.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

final class MovieLocalDataSource: MovieLocalDataSourceProtocol {
    private let cache: MovieCacheProtocol
    private let expirationInterval: TimeInterval = 3600 // 1 hour
    
    init(cache: MovieCacheProtocol) {
        self.cache = cache
    }
    
    func getMovies(category: MovieCategory) async throws -> [Movie]? {
        try await cache.getMovies(category: category, expirationInterval: expirationInterval)
    }
    
    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
        try await cache.saveMovies(movies, category: category)
    }
}
