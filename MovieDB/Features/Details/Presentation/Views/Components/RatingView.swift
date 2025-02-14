//
//  RatingView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            
            Text(String(format: "%.1f", rating))
                .font(.subheadline.bold())
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(4)
    }
}
