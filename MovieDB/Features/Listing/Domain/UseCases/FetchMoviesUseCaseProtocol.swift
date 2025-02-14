//
//  FetchMoviesUseCaseProtocol.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation


protocol FetchMoviesUseCaseProtocol {
    func execute() async throws -> [Movie]
}
