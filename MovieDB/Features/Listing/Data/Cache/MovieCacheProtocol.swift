//
//  MovieCacheProtocol.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

protocol MovieCacheProtocol {
    func getMovies(category: MovieCategory, expirationInterval: TimeInterval) async throws -> [Movie]?
    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws
}
