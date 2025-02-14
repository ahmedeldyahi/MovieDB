//
//  APIEndpointContract.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation
protocol APIEndpointContract {
    var method: HTTPMethod { get }
    var path: String { get }
    var urlRequest: URLRequest? { get }
}


extension APIEndpointContract {
    var method: HTTPMethod { .GET }
    
    var baseURL: URL {
        Configuration.baseURL
    }
}


enum HTTPMethod: String {
    case GET
    case POST
}
