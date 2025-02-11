//
//  APIEndpoint.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation

enum APIEndpoint: APIEndpointContract {
    case nowPlaying
    case popular
    case upcoming
    case movieDetail(id: Int)
    
    var path: String {
        switch self {
        case .nowPlaying: return "/movie/now_playing"
        case .popular: return "/movie/popular"
        case .upcoming: return "/movie/upcoming"
        case .movieDetail(let id): return "/movie/\(id)"
        }
    }
}
