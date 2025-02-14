//
//  MovieLocalDataSourceTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class MovieLocalDataSourceTests: XCTestCase {
    private var mockCache: MockMovieCache!
    private var localDataSource: MovieLocalDataSource!

    override func setUp() {
        super.setUp()
        mockCache = MockMovieCache()
        localDataSource = MovieLocalDataSource(cache: mockCache)
    }

    override func tearDown() {
        mockCache = nil
        localDataSource = nil
        super.tearDown()
    }

    func testGetMovies_whenCacheHasMovies_shouldReturnMovies() async throws {
        // Given
        mockCache.storedMovies = CachedMovie

        // When
        let result = try await localDataSource.getMovies(category: .popular)

        // Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.title, "Cached Movie")
    }

    func testGetMovies_whenCacheIsEmpty_shouldReturnNil() async throws {
        // Given
        mockCache.storedMovies = nil

        // When
        let result = try await localDataSource.getMovies(category: .popular)

        // Then
        XCTAssertNil(result)
    }
}
