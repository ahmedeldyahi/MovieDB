//
//  APIEndpoint.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation

enum APIEndpoint: APIEndpointContract {
    case movies(category: String)
    case movieDetail(id: Int)
    
    var path: String {
        switch self {
        case .movies(category: let endpoint): return endpoint
        case .movieDetail(let id): return "/movie/\(id)"
        }
    }
}
