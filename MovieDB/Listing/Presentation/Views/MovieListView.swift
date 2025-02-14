//
//  MovieListView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var coordinator: AppCoordinator = AppCoordinator()
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            content
                .navigationTitle(viewModel.title)
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailView(
                        viewModel: MovieDetailViewModel(
                            movie: movie,
                            fetchDetailsUseCase: DependencyContainer.shared.makeFetchMovieDetailsUseCase()
                        )
                    )
                }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .success(let movies):
            success(movies)
            
        case .error(let info):
            ErrorView(errorInfo: info) {
                Task{
                    await viewModel.loadMovies()
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func success(_ movies: [Movie]) -> some View {
        if movies.isEmpty {
            EmptyView()
        } else {
            ScrollView(.vertical) {
                LazyVStack{
                    ForEach(movies) { movie in
                        MovieCardView(movie: movie)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .shadow(radius: 1)
                            })
                        
                            .padding(.vertical, 4)
                        
                            .onTapGesture {
                                coordinator.navigateToDetail(movie: movie)
                            }
                        
                    }
                }.padding()
            }
        }
    }
    
}
