//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation
import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigateToDetail(movie: Movie) {
        navigationPath.append(movie)
    }
}
