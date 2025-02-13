//
//  DependencyContainer.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

final class DependencyContainer {
    // Shared instances
    static let shared = DependencyContainer()
    
    // Network
    private lazy var networkService: NetworkService = NetworkManager()
    
    // Cache
    private lazy var movieCache: MovieCacheProtocol = CoreDataMovieCache()
    
    // Data Sources
    private lazy var remoteDataSource: MovieRemoteDataSourceProtocol = {
        MovieRemoteDataSource(networkService: networkService)
    }()
    
    private lazy var localDataSource: MovieLocalDataSourceProtocol = {
        MovieLocalDataSource(cache: movieCache)
    }()
    
    // Repository
    private lazy var movieRepository: MovieRepositoryProtocol = {
        MovieRepository(
            remote: remoteDataSource,
            local: localDataSource
        )
    }()
    
    // Use Cases
    func makeFetchMoviesUseCase(category: MovieCategory) -> FetchMoviesUseCase {
        FetchMoviesUseCase(
            repository: movieRepository,
            category: category
        )
    }
}
