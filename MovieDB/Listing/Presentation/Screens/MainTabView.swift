//
//  MainTabView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        TabView {
            ForEach(MovieCategory.allCases, id: \.self) { category in
                NavigationStack(path: coordinator.path(for: category)) {
                    MovieListView(
                        viewModel: MovieListViewModel(
                            category: category,
                            fetchMoviesUseCase: DependencyContainer.shared.makeFetchMoviesUseCase(category: category)
                        )
                    )
                    .navigationDestination(for: Movie.self) { movie in
                            Text(movie.title)
//                            MovieDetailView(movie: movie, category: category)
                        }
                }
                .tabItem {
                    Label(category.rawValue, systemImage: category.icon)
                }
            }
        }
        .environmentObject(coordinator)
    }
}
#Preview {
    MainTabView()
}



final class NavigationCoordinator: ObservableObject {
    @Published private var navigationPaths: [MovieCategory: NavigationPath] = [:]
    
    func path(for category: MovieCategory) -> Binding<NavigationPath> {
        .init(
            get: { self.navigationPaths[category, default: NavigationPath()] },
            set: { self.navigationPaths[category] = $0 }
        )
    }
    
    func navigateToDetail(movie: Movie, in category: MovieCategory) {
        if navigationPaths[category] == nil {
            navigationPaths[category] = NavigationPath()
        }
        navigationPaths[category]?.append(movie)
    }
    
    func popToRoot(for category: MovieCategory) {
        navigationPaths[category] = NavigationPath()
    }
}
