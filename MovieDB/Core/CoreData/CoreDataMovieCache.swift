//
//  CoreDataMovieCache.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 13/02/2025.
//

import Foundation
import CoreData

final class CoreDataMovieCache: MovieCacheProtocol {
    private let persistentContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init(persistentContainer: NSPersistentContainer = CoreDataStack.shared.persistentContainer) {
        self.persistentContainer = persistentContainer
        self.backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func getMovies(category: MovieCategory, expirationInterval: TimeInterval) async throws -> [Movie]? {
        try await backgroundContext.perform { [weak self] in
            guard let self else { throw AppError.unknown(statusCode: nil, message: "Something went wrong") }
            
            let request = CachedMovie.fetchRequest()
            request.predicate = NSPredicate(
                format: "category == %@ AND lastUpdatedDate >= %@",
                category.rawValue,
                Date().addingTimeInterval(-expirationInterval) as NSDate
            )
            
            let cachedMovies = try self.backgroundContext.fetch(request)
            return cachedMovies.compactMap { $0.toDomainModel() }
        }
    }
    
    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
        try await backgroundContext.perform { [weak self] in
            guard let self else { throw AppError.unknown(statusCode: nil, message: "Something went wrong") }
            
            // Delete old cached movies for this category
            let deleteRequest = NSBatchDeleteRequest(
                fetchRequest: CachedMovie.fetchRequest(for: category))
            try self.backgroundContext.execute(deleteRequest)
            
            // Insert new movies
            for movie in movies {
                let cachedMovie = CachedMovie(context: self.backgroundContext)
                cachedMovie.update(with: movie, category: category)
            }
            
            try self.backgroundContext.save()
        }
    }
}

// MARK: - Core Data Stack
final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
}

// MARK: - Core Data Entity
extension CachedMovie {
    @nonobjc class func fetchRequest(for category: MovieCategory) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedMovie")
        request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        return request
    }
    
    func update(with movie: Movie, category: MovieCategory) {
        self.id = Int64(movie.id)
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.voteAverage = movie.voteAverage ?? 0
        self.category = category.rawValue
        self.lastUpdatedDate = Date()

    }
    
    func toDomainModel() -> Movie? {
        guard let title = title,
              let releaseDate = releaseDate,
              let overview = overview else {
            return nil
        }
        
        return Movie(
            id: Int(id),
            title: title,
            subtitle: posterPath,
            originalTitle: releaseDate,
            overview: overview,
            voteAverage: voteAverage,
            posterPath: posterPath,
            backdropPath: nil,
            releaseDate: releaseDate,
            genres: nil,
            runtime: nil,
            budget: nil,
            revenue: nil,
            status: nil
            
        )
    }
}

// MARK: - Error Handling
enum CacheError: Error {
    case unexpectedError
    case invalidData
    case storageFull
}
