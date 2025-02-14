//
//  MovieRemoteDataSourceTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class MovieRemoteDataSourceTests: XCTestCase {
    private var mockNetworkService: MockNetworkService!
    private var remoteDataSource: MovieRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        remoteDataSource = MovieRemoteDataSource(networkService: mockNetworkService)
    }

    override func tearDown() {
        mockNetworkService = nil
        remoteDataSource = nil
        super.tearDown()
    }

    func testFetchMovies_whenAPISucceeds_shouldReturnMovies() async throws {
        // Given
        
        let jsonData = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Movie A",
                    "subtitle": null,
                    "originalTitle": null,
                    "overview": "Overview A",
                    "voteAverage": 8.0,
                    "posterPath": null,
                    "backdropPath": null,
                    "releaseDate": "2025-01-01",
                    "genres": null,
                    "runtime": null,
                    "budget": null,
                    "revenue": null,
                    "status": null
                }
            ],
            "totalPages": 1,
            "totalResults": 1
        }
        """.data(using: .utf8)!
        
        let expectedMovies = try JSONDecoder().decode(MoviesDBRoot<[Movie]>.self, from: jsonData)
        mockNetworkService.fetchResult = expectedMovies

        // When
        let result = try await remoteDataSource.fetchMovies(category: .popular)

        // Then
        XCTAssertEqual(result.results?.count, 1)
        XCTAssertEqual(result.results?.first?.title, "Movie A")
    }

    func testFetchMovies_whenAPIFails_shouldThrowError() async {
        // Given
        mockNetworkService.fetchError = AppError.offline
        
        // When & Then
        await assertThrowsError(expectedError: .offline) {
            try await remoteDataSource.fetchMovies(category: .popular)
        }
    }
    
    
    func testFetchMovieDetails_whenAPISucceeds_shouldReturnMovieDetail() async throws {
        // Given
        
        
        mockNetworkService.fetchResult = CachedMovie.first

        // When
        let result = try await remoteDataSource.fetchMovieDetails(movieId: 1)

        // Then
        XCTAssertEqual(result.title, CachedMovie.first?.title)
    }

    func testFetchMovieDetails_whenAPIFails_shouldThrowError() async {
        // Given
        mockNetworkService.fetchError = AppError.offline
        
        // When & Then
        await assertThrowsError(expectedError: .offline) {
            try await remoteDataSource.fetchMovieDetails(movieId: 1)
        }
    }
}
