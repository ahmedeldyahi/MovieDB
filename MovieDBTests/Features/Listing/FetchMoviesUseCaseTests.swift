//
//  FetchMoviesUseCaseTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class FetchMoviesUseCaseTests: XCTestCase {
    private var mockRepository: MockMovieRepository!
    private var useCase: FetchMoviesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        useCase = FetchMoviesUseCase(repository: mockRepository, category: .popular)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_whenRepositorySucceeds_shouldReturnMovies() async throws {
        // Given
        let expectedMovies = CachedMovie
        mockRepository.fetchMoviesResult = expectedMovies

        // When
        let result = try await useCase.execute()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Cached Movie")
    }

    func testExecute_whenRepositoryFails_shouldThrowError() async {
        // Given
        mockRepository.shouldThrowError = true

        // When & Then
        
        await assertThrowsError(expectedError: .offline) {
            try await useCase.execute()
        }

    }
}
