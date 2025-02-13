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
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .success(let movies):
            if movies.isEmpty {
                EmptyView() // Keeping as requested
            } else {
                List(movies) { movie in
                    MovieCardView(movie: movie)
                        .onTapGesture {
                            coordinator.navigateToDetail(movie: movie, in: viewModel.category)
                        }
                }
            }
            
        case .error:
            Text("error")
        }
    }
}
