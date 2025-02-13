//
//  MovieListView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import SwiftUI

struct MovieListView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.title)
            .task {
                await viewModel.loadMovies()
            }
    }
    
    var content: some View {
        Group {
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
    }
    
    @ViewBuilder
    fileprivate func success(_ movies: [Movie]) -> some View {
        if movies.isEmpty {
            EmptyView()
        } else {
            List(movies) { movie in
                MovieCardView(movie: movie)
                    .onTapGesture {
                        coordinator.navigateToDetail(movie: movie, in: viewModel.category)
                    }
            }
        }
    }
    
}
