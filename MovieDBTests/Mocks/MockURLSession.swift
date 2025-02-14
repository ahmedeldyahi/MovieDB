//
//  MockURLSession.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation
import XCTest
@testable import MovieDB

final class MockURLSession: URLSessionProtocol {
    var testData: Data?
    var testResponse: URLResponse?
    var testError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = testError {
            throw error
        }
        guard let data = testData, let response = testResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}

final class MockAPIEndpoint: APIEndpointContract {
    var badURL: Bool = false
    var path: String = ""
    
    init(badURL: Bool = false, path: String = "") {
        self.badURL = badURL
        self.path = path
    }
    var urlRequest: URLRequest? {
        if badURL {
            return nil
        }
        return URLRequest(url: URL(string: "https://api.example.com")!)
    }
}

final class MockNetworkMonitor: NetworkMonitorContract {
    var status: NetworkStatus = .connected
}


// MARK: - Mock NetworkService
final class MockNetworkService: NetworkService {
    var fetchResult: Any?
    var fetchError: Error?

    func fetch<T: Decodable>(endpoint: APIEndpointContract) async throws -> T {
        if let fetchError = fetchError {
            throw fetchError
        }
        guard let fetchResult = fetchResult as? T else {
            throw AppError.decodingFailed
        }
        return fetchResult
    }
}

// MARK: - Mock Cache
final class MockMovieCache: MovieCacheProtocol {
    var storedMovies: [Movie]?
    var shouldThrowError = false

    func getMovies(category: MovieCategory, expirationInterval: TimeInterval) async throws -> [Movie]? {
        if shouldThrowError {
            throw AppError.unknown(message: "Cache error")
        }
        return storedMovies
    }

    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
        if shouldThrowError {
            throw AppError.unknown(message: "Cache save error")
        }
        storedMovies = movies
    }
}

// MARK: - Mock Repository
final class MockMovieRepository: MovieRepositoryProtocol {
    var fetchMoviesResult: [Movie]?
    var fetchMovieDetailsResult: Movie?
    var shouldThrowError = false

    func fetchMovies(category: MovieCategory) async throws -> [Movie] {
        if shouldThrowError {
            throw AppError.offline
        }
        return fetchMoviesResult ?? []
    }

    func fetchMovieDetails(movieId: Int) async throws -> Movie {
        if shouldThrowError {
            throw AppError.offline
        }
        guard let movie = fetchMovieDetailsResult else {
            throw AppError.emptyData
        }
        return movie
    }
}


final class MockMovieRemoteDataSource: MovieRemoteDataSourceProtocol {
    var fetchMoviesResult: MoviesDBRoot<[Movie]>?
    var fetchMovieDetailsResult: Movie?
    var shouldThrowError = false
    var errorToThrow: Error = AppError.unknown(message: "Mock error")

    func fetchMovies(category: MovieCategory) async throws -> MoviesDBRoot<[Movie]> {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let result = fetchMoviesResult else {
            throw AppError.emptyData
        }
        return result
    }

    func fetchMovieDetails(movieId: Int) async throws -> Movie {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let movie = fetchMovieDetailsResult else {
            throw AppError.emptyData
        }
        return movie
    }
}

final class MockMovieLocalDataSource: MovieLocalDataSourceProtocol {
    var storedMovies: [Movie]?
    var shouldThrowError = false
    var errorToThrow: Error = AppError.unknown(message: "Mock cache error")

    func getMovies(category: MovieCategory) async throws -> [Movie]? {
        if shouldThrowError {
            throw errorToThrow
        }
        return storedMovies
    }

    func saveMovies(_ movies: [Movie], category: MovieCategory) async throws {
        if shouldThrowError {
            throw errorToThrow
        }
        storedMovies = movies
    }
}


final class MockFetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    var moviesToReturn: [Movie]?
    var shouldThrowError = false
    var errorToThrow: Error = AppError.unknown(message: "Mock error")

    func execute() async throws -> [Movie] {
        if shouldThrowError {
            throw errorToThrow
        }
        return moviesToReturn ?? []
    }
}


final class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCaseProtocol {
    var movieToReturn: Movie?
    var shouldThrowError = false
    var errorToThrow: Error = AppError.unknown(message: "Mock error")

    func execute(movieId: Int) async throws -> Movie {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let movie = movieToReturn else {
            throw AppError.emptyData
        }
        return movie
    }
}
struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}


let CachedMovie = [
    Movie(
        id: 1,
        title: "Cached Movie",
        subtitle: nil,
        originalTitle: nil,
        overview: "This is a test movie",
        voteAverage: 7.5,
        posterPath: nil,
        backdropPath: nil,
        releaseDate: "2025-01-01",
        genres: [Genre(id: 28, name: "Action")],
        runtime: 120,
        budget: 100000000,
        revenue: 500000000,
        status: "Released"
    )
]


let FetchedMovies = [
    Movie(
        id: 1,
        title: "Fetched Movie",
        subtitle: nil,
        originalTitle: nil,
        overview: "This is a test movie",
        voteAverage: 7.5,
        posterPath: nil,
        backdropPath: nil,
        releaseDate: "2025-01-01",
        genres: [Genre(id: 28, name: "Action")],
        runtime: 120,
        budget: 100000000,
        revenue: 500000000,
        status: "Released"
    )
]

let jsonData = """
{
    "page": 1,
    "results": [
        {
            "id": 1,
            "title": "Fetched Movie",
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

