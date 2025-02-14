//
//  Movie.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation
import SwiftUI
struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let originalTitle: String?
    let overview: String?
    let voteAverage: Double?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    
    let genres: [Genre]?
    let runtime: Int?
    let budget: Int?
    let revenue: Int?
    let status: String?
    
    var formattedRuntime: String? {
        guard let runtime = runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    var formattedBudget: String? {
        budget.map {
            NumberFormatter.currencyFormatter.string(from: NSNumber(value: $0))?.replacingOccurrences(of: "US", with: "")
        } ?? nil
    }
    
    var formattedRevenue: String? {
        revenue.map {
            NumberFormatter.currencyFormatter.string(from: NSNumber(value: $0))?.replacingOccurrences(of: "US", with: "")
        } ?? nil
    }
    
    var formattedReleaseDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .long
        outputFormatter.locale = Locale.current
        
        guard let date = inputFormatter.date(from: releaseDate) else {
            return releaseDate
        }
        
        return outputFormatter.string(from: date)
    }
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
}

struct Genre: Decodable,Identifiable, Hashable {
    let id: Int?
    let name: String?
}
