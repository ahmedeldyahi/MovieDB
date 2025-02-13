//
//  MovieCardView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .bottomLeading) {
                movieImage
                ratingBadge
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(movie.releaseDate)
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.8))
                }
               
                Text(movie.overview ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }
        }
        .padding(.vertical, 8)
    }
    
    
    private var movieImage: some View {
         AsyncImage(url: URL(string: "\(imageBaseURL)\(movie.posterPath ?? "")")) { phase in
             switch phase {
             case .empty:
                 ProgressView()
                     .frame(height: 220)
                     .frame(maxWidth: .infinity)
             case .success(let image):
                 image
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(height: 220)
                     .frame(maxWidth: .infinity)
                     .clipped()
             case .failure:
                 Image(systemName: "film.fill")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 220)
                     .frame(maxWidth: .infinity)
                     .foregroundColor(.secondary)
             @unknown default:
                 EmptyView()
             }
         }
//         .clipShape(RoundedRectangle(cornerRadius: 16))
     }
    private var ratingBadge: some View {
        Text("\(movie.voteAverage ?? 0, specifier: "%.1f")★")
            .font(.system(size: 14, weight: .bold))
            .padding(6)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
//            .offset(x: -4, y: 4)
    }
}


let sampleMovie = Movie(
    id: 939243,
    //    posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg",
    title: "Sonic the Hedgehog 3",
    subtitle: "Sonic the Hedgehog 3",
    originalTitle: "Sonic the Hedgehog 3",
    overview: "A fading celebrity decides to use a black market drug, a cell-replicating substance that temporarily creates a younger, better version of herself.",
    voteAverage: 7.769, 
    posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg",
    releaseDate: "2024-11-21"
)
