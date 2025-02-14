//
//  MainTabView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MovieCategory = .nowPlaying

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MovieCategory.allCases, id: \.self) { category in
                    let viewModel = MovieListViewModel(
                        category: category,
                        fetchMoviesUseCase: DependencyContainer.shared.makeFetchMoviesUseCase(category: category)
                    )
                    MovieListView(viewModel: viewModel)
                .tabItem {
                    Label(category.rawValue, systemImage: category.icon)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
