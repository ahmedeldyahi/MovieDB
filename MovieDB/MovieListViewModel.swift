//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation
@MainActor
class MovieListViewModel: ObservableObject {
    let category: MovieCategory
    @Published var movies: [Movie] = []
    let networkManager = NetworkManager()
    
    init(category: MovieCategory) {
        self.category = category
        
    }

    func loadMovies() async {
        Task {
            do {
                let result: MoviesDBRootDTO<[Movie]>  = try await networkManager.fetch(endpoint: APIEndpoint.upcoming)
                self.movies = result.results ?? []
            }catch{
                print(error)
            }
        }
    }
    
}
