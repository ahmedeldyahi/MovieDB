//
//  MovieListViewModelTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB

final class MovieListViewModelTests: XCTestCase {
    private var mockUseCase: MockFetchMoviesUseCase!
    private var viewModel: MovieListViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchMoviesUseCase()
        viewModel = MovieListViewModel(category: .popular, fetchMoviesUseCase: mockUseCase)
    }

    @MainActor
    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testLoadMovies_whenAPISucceeds_shouldSetSuccessState() async {
        // Given
        let expectedMovies = CachedMovie
        mockUseCase.moviesToReturn = expectedMovies

        // When
        await viewModel.loadMovies()

        // Then
        if case let .success(movies) = viewModel.state {
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.title, CachedMovie.first?.title)
        } else {
            XCTFail("Expected success state but got \(viewModel.state)")
        }
    }

    @MainActor
    func testLoadMovies_whenAPIFails_shouldSetErrorState() async {
        // Given
        mockUseCase.shouldThrowError = true
        mockUseCase.errorToThrow = AppError.offline

        // When
        await viewModel.loadMovies()

        // Then
        if case let .error(errorInfo) = viewModel.state {
            XCTAssertEqual(errorInfo.message, AppError.offline.errorDescription)
        } else {
            XCTFail("Expected error state but got \(viewModel.state)")
        }
    }

    @MainActor
    func testLoadMovies_shouldStartWithLoadingState() async {
        // Given
        XCTAssertEqual(viewModel.state, .loading, "Initial state should be loading")
        
        // When
        await viewModel.loadMovies()

        // Then
        // The state should transition, so it should NOT still be `.loading`
        XCTAssertNotEqual(viewModel.state, .loading, "State should change after loadMovies()")
    }
}
