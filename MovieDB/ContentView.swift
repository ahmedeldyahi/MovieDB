//
//  ContentView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import SwiftUI

struct ContentView: View {
    let networkManager = NetworkManager()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button("Hello, world!") {
                ErrorManager.shared.show(.offline)
            }
        }.task {
            do {
                let result: Movie  = try await networkManager.fetch(endpoint: APIEndpoint.movieDetail(id: 1064213))
                print(result)
            }catch{
                print(error)
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct Movie:Decodable {
  let id: Int
  let title: String
  let releaseDate: String
  let posterPath: String?
}


// MARK: - MoviesDBRootModel
struct MoviesDBRootDTO<T: Decodable>: Decodable {
    let page: Int?
    let results: T?
    let totalPages, totalResults: Int?
}
