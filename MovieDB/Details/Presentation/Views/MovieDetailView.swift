//
//  MovieDetailView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject var viewModel: MovieDetailViewModel    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let movie):
                contentView(movie: movie)
            case .error(let errorInfo):
                ErrorView(errorInfo: errorInfo) {
                    viewModel.loadDetails()
                }
            }
        }
        .navigationTitle(viewModel.movie.title)
        .task {
            viewModel.loadDetails()
        }
    }
    
    private func contentView(movie: Movie) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection(movie: movie)
                infoGridSection(movie: movie)
                overviewSection(movie: movie)
                genresSection(movie: movie)
            }
            .padding()
        }
    }
    
    private func headerSection(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            movieImage(movie.backdropPath ?? "")
            HStack {
                Text(movie.formattedReleaseDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let runtime = movie.formattedRuntime {
                    Text("• \(runtime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            RatingView(rating: movie.voteAverage ?? 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    
    private func movieImage(_ path: String) -> some View  {
        CachedAsyncImage(
            url: URL(string: "\(Configuration.imageBaseURL)\(path)")
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
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: 450)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
    
    private func infoGridSection(movie: Movie) -> some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            if let budget = movie.formattedBudget{
                InfoItemView(label: "Budget", value: budget)
            }
            if let revenue = movie.formattedRevenue { 
                InfoItemView(label: "Revenue", value: revenue)
            }
            if let status = movie.status {
                InfoItemView(label: "Status", value: status)
            }
        }
    }
    
    private func overviewSection(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            
            Text(movie.overview ?? "")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func genresSection(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Genres")
                .font(.headline)
            
            let columns = [
                GridItem(.flexible(minimum: 80, maximum: .infinity), spacing: 8)
            ]
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: columns,alignment: .center) {
                    ForEach(movie.genres ?? [], id: \.self) { genre in
                        Text(genre.name ?? "")
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}


