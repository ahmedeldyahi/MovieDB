//
//  MoviesDBRoot.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation

struct MoviesDBRoot<T: Decodable>: Decodable {
    let page: Int?
    let results: T?
    let totalPages, totalResults: Int?
}
