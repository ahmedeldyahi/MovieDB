//
//  FetchMoviesUseCase.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

struct FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    private let category: MovieCategory
    
    init(repository: MovieRepositoryProtocol, category: MovieCategory) {
        self.repository = repository
        self.category = category
    }
    
    func execute() async throws -> [Movie] {
        try await repository.fetchMovies(category: category)
    }
}
