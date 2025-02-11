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
    let category: MovieCategory
    
    init(category: MovieCategory) {
        self.category = category
        _viewModel = StateObject(wrappedValue: MovieListViewModel(category: category))
    }
    
    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                ProgressView()
//            } else if let error = viewModel.error {
//                ErrorView(error: error)
//            } else {
                List(viewModel.movies) { movie in
                    MovieCardView(movie: movie)
                        .onTapGesture {
                            coordinator.navigateToMovie(movie)
                        }
                }
                .listStyle(.plain)
//            }
//        }
        .navigationTitle(category.rawValue)
        .task {
            await viewModel.loadMovies()
        }
    }
}

//#Preview {
//    MovieListView()
//}
