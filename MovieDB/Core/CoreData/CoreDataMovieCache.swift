//
//  CoreDataMovieCache.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 13/02/2025.
//

import Foundation
import CoreData

final class CoreDataMovieCache: MovieCacheProtocol {
    
    // MARK: - Singleton
    static let shared = CoreDataMovieCache()

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    private init(container: NSPersistentContainer = CoreDataStack.shared.persistentContainer) {
        self.container = container
        self.context = container.viewContext
    }
    
    /// Internal initializer for testing
    internal init(persistentStoreDescription: NSPersistentStoreDescription) {
        self.container = NSPersistentContainer(name: "Model")
        self.container.persistentStoreDescriptions = [persistentStoreDescription]
        self.container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack initialization failed: \(error)")
            }
        }
        self.context = container.viewContext
    }
    
    // MARK: - Fetch Movies (Array)
    func getMovies(category: MovieCategory, expirationInterval: TimeInterval) async throws -> [Movie]? {
        try await context.perform {
            let request: NSFetchRequest<CachedMovie> = CachedMovie.fetchRequest()
            request.predicate = NSPredicate(
                format: "category == %@ AND lastUpdatedDate >= %@",
                category.rawValue,
                Date().addingTimeInterval(-expirationInterval) as NSDate
            )
            
            let cachedMovies = try self.context.fetch(request)
            return cachedMovies.compactMap { $0.toDomainModel() }
        }
    }
    
    // MARK: - Save Movies (Array)
    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
        try await deleteMovies(for: category)

        try await context.perform {
            // Insert new movies
            for movie in movies {
                let cachedMovie = CachedMovie(context: self.context)
                cachedMovie.update(with: movie, category: category)
            }

            try self.context.save()
        }
    }


    // MARK: - Delete Movies by Category
    private func deleteMovies(for category: MovieCategory) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<CachedMovie> = CachedMovie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "category == %@", category.rawValue)
            
            let movies = try self.context.fetch(fetchRequest)
            
            for movie in movies {
                self.context.delete(movie)
            }
            
            try self.context.save()
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
