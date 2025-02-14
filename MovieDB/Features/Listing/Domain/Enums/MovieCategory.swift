//
//  MovieCategory.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation

enum MovieCategory: String, CaseIterable,Identifiable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
    
    var id: String {
        self.rawValue
    }
    
    var icon: String {
        return switch self {
        case .nowPlaying : "film"
        case .popular : "flame"
        case .upcoming : "calendar"
        }
    }
    
    var endpoint: String {
        switch self {
        case .nowPlaying: return "/movie/now_playing"
        case .popular: return "/movie/popular"
        case .upcoming: return "/movie/upcoming"
        }
    }
}
