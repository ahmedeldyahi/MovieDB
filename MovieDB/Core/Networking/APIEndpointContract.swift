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
}


extension APIEndpointContract {
    var method: HTTPMethod { .GET }
    
    var baseURL: URL {
        Configuration.baseURL
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


enum HTTPMethod: String {
    case GET
    case POST
}
