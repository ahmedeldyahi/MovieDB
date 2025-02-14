//
//  MovieRepositoryProtocol.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

protocol MovieRepositoryProtocol {
    func fetchMovies(category: MovieCategory) async throws -> [Movie]
    func fetchMovieDetails(movieId: Int) async throws -> Movie
}
