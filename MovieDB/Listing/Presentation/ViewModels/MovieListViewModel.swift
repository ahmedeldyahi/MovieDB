//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//
import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var state: ViewState<[Movie]> = .loading
    let title: String
    let category: MovieCategory
    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    
    init(category: MovieCategory, fetchMoviesUseCase: FetchMoviesUseCaseProtocol) {
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
            var message = ""
            if let err = error as? AppError {
                message = err.errorDescription
            } else {
                message = error.localizedDescription
            }
            
            state = .error(.init(message: message))
            
        }
    }
}
