//
//  MovieRemoteDataSourceProtocol.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

protocol MovieRemoteDataSourceProtocol {
    func fetchMovies(category: MovieCategory) async throws -> MoviesDBRoot<[Movie]>
    func fetchMovieDetails(movieId: Int) async throws -> Movie
}
