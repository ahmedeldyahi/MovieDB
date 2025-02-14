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
    
    var urlRequest: URLRequest? {
          var components = URLComponents()
          components.scheme = baseURL.scheme
          components.host = baseURL.host
          components.path = baseURL.path + path
          
          
          guard let url = components.url else { return nil }
          
          var request = URLRequest(url: url)
          request.httpMethod = method.rawValue
              request.setValue(
                  "Bearer \(Configuration.apiKey)",
                  forHTTPHeaderField: "Authorization"
              )
          
          return request
      }
}
