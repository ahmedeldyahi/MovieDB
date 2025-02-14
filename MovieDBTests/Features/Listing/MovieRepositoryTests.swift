//
//  MovieRepositoryTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class MovieRepositoryTests: XCTestCase {
    private var mockRemoteDataSource: MockMovieRemoteDataSource!
    private var mockLocalDataSource: MockMovieLocalDataSource!
    private var repository: MovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockMovieRemoteDataSource()
        mockLocalDataSource = MockMovieLocalDataSource()
        repository = MovieRepository(remote: mockRemoteDataSource, local: mockLocalDataSource)
    }
    
    override func tearDown() {
        mockRemoteDataSource = nil
        mockLocalDataSource = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchMovies_whenCacheHasMovies_shouldReturnCachedMovies() async throws {
        // Given
        mockLocalDataSource.storedMovies = CachedMovie
        
        // When
        let result = try await repository.fetchMovies(category: .popular)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Cached Movie")
    }
    
    func testFetchMovies_whenCacheIsEmpty_shouldFetchFromRemoteAndCacheIt() async throws {
        // Given
        let expectedMovies = try JSONDecoder().decode(MoviesDBRoot<[Movie]>.self, from: jsonData)
        
        mockRemoteDataSource.fetchMoviesResult = expectedMovies
        mockLocalDataSource.storedMovies = nil
        
        // When
        let result = try await repository.fetchMovies(category: .popular)
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Fetched Movie")
        XCTAssertEqual(mockLocalDataSource.storedMovies?.count, 1)
    }
    
    
    func testFetchMovieDetails_whenAPISucceeds_shouldReturnMovie() async throws {
        // Given
        let expectedMovie = Movie(id: 1, title: "Test Movie", subtitle: nil, originalTitle: nil, overview: "Test Overview", voteAverage: 8.5, posterPath: nil, backdropPath: nil, releaseDate: "2025-01-01", genres: nil, runtime: 120, budget: nil, revenue: nil, status: "Released")
        mockRemoteDataSource.fetchMovieDetailsResult = expectedMovie
        
        // When
        let result = try await repository.fetchMovieDetails(movieId: 1)
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "Test Movie")
        XCTAssertEqual(result.overview, "Test Overview")
    }
    
    func testFetchMovieDetails_whenAPIFails_shouldThrowError() async {
        // Given
        mockRemoteDataSource.shouldThrowError = true
        mockRemoteDataSource.errorToThrow = AppError.offline
        
        // When & Then
        await assertThrowsError(expectedError: .offline) {
            try await repository.fetchMovieDetails(movieId: 1)
        }
    }
}
