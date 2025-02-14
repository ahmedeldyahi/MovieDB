//
//  FetchMovieDetailsUseCase.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation
struct FetchMovieDetailsUseCase {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(movieId: Int) async throws -> Movie {
        try await repository.fetchMovieDetails(movieId: movieId)
    }
}
