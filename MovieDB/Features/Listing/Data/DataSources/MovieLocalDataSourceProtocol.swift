//
//  MovieLocalDataSourceProtocol.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

protocol MovieLocalDataSourceProtocol {
    func getMovies(category: MovieCategory) async throws -> [Movie]?
    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws
}
