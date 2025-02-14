//
//  MovieDetailViewModelTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import XCTest
@testable import MovieDB
import Combine
final class MovieDetailViewModelTests: XCTestCase {
    private var mockUseCase: MockFetchMovieDetailsUseCase!
    private var viewModel: MovieDetailViewModel!
    private var testMovie: Movie!
    private var cancellables:Set<AnyCancellable>!

    @MainActor
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchMovieDetailsUseCase()
        testMovie = Movie(id: 1, title: "Test Movie", subtitle: nil, originalTitle: nil, overview: "Test Overview", voteAverage: 8.5, posterPath: nil, backdropPath: nil, releaseDate: "2025-01-01", genres: nil, runtime: 120, budget: nil, revenue: nil, status: "Released")
        viewModel = MovieDetailViewModel(movie: testMovie, fetchDetailsUseCase: mockUseCase)
        cancellables = Set<AnyCancellable>()

    }
    
    @MainActor
    override func tearDown() {
        mockUseCase = nil
        viewModel = nil
        testMovie = nil
         cancellables = nil

        super.tearDown()
    }
    
    func testLoadDetails_whenAPISucceeds_shouldSetSuccessState() async {
        // Given
        let expectedMovie = Movie(id: 1, title: "Detailed Test Movie", subtitle: nil, originalTitle: nil, overview: "Detailed Overview", voteAverage: 9.0, posterPath: nil, backdropPath: nil, releaseDate: "2025-01-01", genres: nil, runtime: 140, budget: 100000000, revenue: 500000000, status: "Released")
        mockUseCase.movieToReturn = expectedMovie
        
        //        then
        await viewModel.$state.sink { state in
            
            if case .success(let movie) = state {
                XCTAssertEqual(movie.title, "Detailed Test Movie")
            }
        }
        .store(in: &cancellables)
        
        // When
        await viewModel.loadDetails()
        
    }
    
    func testLoadDetails_whenAPIFails_shouldSetErrorState() async {
        // Given
        mockUseCase.shouldThrowError = true
        mockUseCase.errorToThrow = AppError.decodingFailed
        let expectedErrorMessage = AppError.decodingFailed.errorDescription
        
        //        then
        await viewModel.$state.sink { state in
            
            if case .error(let info) = state {
                XCTAssertEqual(info.message, expectedErrorMessage)
            }
        }
        .store(in: &cancellables)
        
        // When
        await viewModel.loadDetails()
    }
    
    @MainActor
    func testLoadDetails_shouldStartWithLoadingState() async {
        //        then
         viewModel.$state.sink { [weak self] state in
            guard let self = self else {return}
            if case .loading = state {
                XCTAssertEqual(viewModel.state, .loading, "Initial state should be loading")
            }
        }
        .store(in: &cancellables)
        // When
         viewModel.loadDetails()
    }
}
