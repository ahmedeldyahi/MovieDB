//
//  FetchMovieDetailsUseCaseTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class FetchMovieDetailsUseCaseTests: XCTestCase {
    private var mockRepository: MockMovieRepository!
    private var useCase: FetchMovieDetailsUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        useCase = FetchMovieDetailsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func testExecute_whenRepositorySucceeds_shouldReturnMovie() async throws {
        // Given
        let expectedMovie = CachedMovie.first
        mockRepository.fetchMovieDetailsResult = expectedMovie

        // When
        let result = try await useCase.execute(movieId: 1)

        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, CachedMovie.first?.title)
    }

    func testExecute_whenRepositoryFails_shouldThrowError() async {
        // Given
        mockRepository.shouldThrowError = true

        // When & Then
        await assertThrowsError(expectedError: .offline) {
            try await useCase.execute(movieId: 1)
        }
    }
}
