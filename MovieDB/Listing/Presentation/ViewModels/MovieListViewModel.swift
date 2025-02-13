//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//
import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var state: ViewState<[Movie]> = .idle
    let title: String
    let category: MovieCategory
    private let fetchMoviesUseCase: FetchMoviesUseCase
    
    init(category: MovieCategory, fetchMoviesUseCase: FetchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.category = category
        self.title = category.rawValue
    }
    
    func loadMovies() async {
        state = .loading
        do {
            let movies = try await fetchMoviesUseCase.execute()
            state = .success(movies)
        } catch {
            state = .error(.init(
                message: error.localizedDescription,
                retryable: true
            ))
        }
    }
}
