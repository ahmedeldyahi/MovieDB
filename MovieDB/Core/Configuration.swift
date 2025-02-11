//
//  Configuration.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation

struct Configuration {
    static let baseURL: URL  = URL(string: "https://api.themoviedb.org/3")!
    static let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""

}
