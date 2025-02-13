//
//  MovieRepository.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let remoteDataSource: MovieRemoteDataSourceProtocol
    private let localDataSource: MovieLocalDataSourceProtocol
    
    init(remote: MovieRemoteDataSourceProtocol, local: MovieLocalDataSourceProtocol) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }
    
    func fetchMovies(category: MovieCategory) async throws -> [Movie] {
        do {
            let moviesDTO = try await remoteDataSource.fetchMovies(category: category)
            let movies =  moviesDTO.results ?? []
            
            try await localDataSource.saveMovies(movies, category: category)
            
            return movies
        } catch {
            if let cachedMovies = try? await localDataSource.getMovies(category: category) {
                return cachedMovies
            }
            throw error
        }
    }
}
