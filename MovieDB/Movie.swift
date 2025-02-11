//
//  Movie.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let originalTitle: String?
    let overview: String?
    let voteAverage: Double?
    let posterPath: String?
    let releaseDate: String
}

// MARK: - MoviesDBRootModel
struct MoviesDBRootDTO<T: Decodable>: Decodable {
    let page: Int?
    let results: T?
    let totalPages, totalResults: Int?
}
