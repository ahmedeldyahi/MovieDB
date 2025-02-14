//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var state: ViewState<Movie> = .loading
    let movie: Movie
    private let fetchDetailsUseCase: FetchMovieDetailsUseCase
    
    init(movie: Movie, fetchDetailsUseCase: FetchMovieDetailsUseCase) {
        self.movie = movie
        self.fetchDetailsUseCase = fetchDetailsUseCase
    }
    
    func loadDetails() {
        Task {
            state = .loading
            do {
                let detailedMovie = try await fetchDetailsUseCase.execute(movieId: movie.id)
                state = .success(detailedMovie)
            } catch {
                state = .error(.init(
                    message: (error as? AppError)?.errorDescription ?? error.localizedDescription
                ))
            }
        }
    }
}
