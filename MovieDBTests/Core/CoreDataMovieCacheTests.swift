//
//  CoreDataMovieCacheTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
import CoreData
@testable import MovieDB


final class CoreDataMovieCacheTests: XCTestCase {
    private var movieCache: CoreDataMovieCache!

    override func setUp() {
        super.setUp()
        
        movieCache = CoreDataMovieCache.createForTesting()
    }

    override func tearDown() {
        movieCache = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testSaveAndGetMovies_whenValidMovies_shouldReturnCorrectData() async throws {
        // Given
        let movies = [
            Movie(id: 1, title: "Movie A", subtitle: nil, originalTitle: nil, overview: "Overview A", voteAverage: 8.0, posterPath: nil, backdropPath: nil, releaseDate: "2025-01-01", genres: nil, runtime: nil, budget: nil, revenue: nil, status: nil),
            Movie(id: 2, title: "Movie B", subtitle: nil, originalTitle: nil, overview: "Overview B", voteAverage: 7.5, posterPath: nil, backdropPath: nil, releaseDate: "2025-02-01", genres: nil, runtime: nil, budget: nil, revenue: nil, status: nil)
        ]

        let category = MovieCategory.popular
        
        // When
        try await movieCache.saveMovies(movies, category: category)
        let fetchedMovies = try await movieCache.getMovies(category: category, expirationInterval: 60)

        // Then
        XCTAssertNotNil(fetchedMovies)
        XCTAssertEqual(fetchedMovies?.count, 2)
    }

    func testGetMovies_whenEmptyCache_shouldReturnEmpty() async throws {
        // Given
        let category = MovieCategory.popular

        // When
        let fetchedMovies = try await movieCache.getMovies(category: category, expirationInterval: 60)

        // Then
        XCTAssertTrue(fetchedMovies?.isEmpty ?? true)
    }

    func testSaveMovies_shouldReplaceOldData() async throws {
        // Given
        let oldMovies = [
            Movie(id: 4, title: "Old Movie 1", subtitle: nil, originalTitle: nil, overview: "Old Overview", voteAverage: 5.5, posterPath: nil, backdropPath: nil, releaseDate: "2024-11-01", genres: nil, runtime: nil, budget: nil, revenue: nil, status: nil)
        ]
        let newMovies = [
            Movie(id: 5, title: "New Movie", subtitle: nil, originalTitle: nil, overview: "New Overview", voteAverage: 9.0, posterPath: nil, backdropPath: nil, releaseDate: "2025-03-01", genres: nil, runtime: nil, budget: nil, revenue: nil, status: nil)
        ]
        let category = MovieCategory.nowPlaying

        // When
        try await movieCache.saveMovies(oldMovies, category: category)
        try await movieCache.saveMovies(newMovies, category: category)
        
        let fetchedMovies = try await movieCache.getMovies(category: category, expirationInterval: 60)

        // Then
        XCTAssertEqual(fetchedMovies?.count, 1)
        XCTAssertEqual(fetchedMovies?.first?.title, "New Movie")
    }
}


extension CoreDataMovieCache {
    static func createForTesting() -> CoreDataMovieCache {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        return CoreDataMovieCache(persistentStoreDescription: description)
    }
}
