//
//  MainTabView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import SwiftUI

enum MovieCategory: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
}

struct MainTabView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        TabView {
            navigationStack(for: .nowPlaying)
                .tabItem { Label("Now Playing", systemImage: "film") }
            
            navigationStack(for: .popular)
                .tabItem { Label("Popular", systemImage: "flame") }
            
            navigationStack(for: .upcoming)
                .tabItem { Label("Upcoming", systemImage: "calendar") }
        }
        .environmentObject(coordinator)
    }
    
    private func navigationStack(for category: MovieCategory) -> some View {
        NavigationStack(path: $coordinator.path) {
            MovieListView(category: category)
                .navigationDestination(for: Movie.self) { movie in
//                    MovieDetailView(movie: movie)
                    Text(movie.title)
                }
        }
    }
}
#Preview {
    MainTabView()
}



final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateToMovie(_ movie: Movie) {
        path.append(movie)
    }
    
    func navigateBack() {
        path.removeLast()
    }
}
