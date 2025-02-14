//
//  MovieCardView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    
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
                    Text(movie.formattedReleaseDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
               
                Text(movie.overview ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }
            .padding(.horizontal, 4)
        }
        .padding(.bottom, 8)
    }
    
    private var movieImage: some View  {
        CachedAsyncImage(
            url: URL(string: "\(Configuration.imageBaseURL)\(movie.posterPath ?? "")")
        ) {
            ProgressView()
                .frame(maxWidth: .infinity)
        } content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
        } failure: {
            Image(systemName: "film.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: 220)
        .cornerRadius(8)
    }
    private var ratingBadge: some View {
        Text("\(movie.voteAverage ?? 0, specifier: "%.1f")★")
            .font(.system(size: 14, weight: .bold))
            .padding(6)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
    }
}
