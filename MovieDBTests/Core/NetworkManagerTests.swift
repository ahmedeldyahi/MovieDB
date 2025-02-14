//
//  NetworkManagerTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//
import Foundation
import XCTest
@testable import MovieDB

final class NetworkManagerTests: XCTestCase {
    private var mockSession: MockURLSession!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var networkManager: NetworkManager!
    private typealias TestError = AppError
    
    // MARK: - Test Setup
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockNetworkMonitor = MockNetworkMonitor()
        networkManager = NetworkManager(
            session: mockSession,
            networkMonitor: mockNetworkMonitor
        )
    }
    
    override func tearDown() {
        mockSession = nil
        mockNetworkMonitor = nil
        networkManager = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func configureSession(
        data: Data? = nil,
        response: HTTPURLResponse? = nil,
        networkStatus: NetworkStatus = .connected
    ) {
        mockSession.testData = data
        mockSession.testResponse = response
        mockNetworkMonitor.status = networkStatus
    }
    
    private func validTestModelData() -> Data {
        """
        {
            "id": 1,
            "name": "Test Movie"
        }
        """.data(using: .utf8)!
    }
    
    private func validHTTPResponse(statusCode: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    // MARK: - Tests
    
    func testFetch_whenValidResponse_shouldReturnDecodedObject() async throws {
        // Given
        configureSession(
            data: validTestModelData(),
            response: validHTTPResponse()
        )
        
        // When
        let result: TestModel = try await networkManager.fetch(endpoint: MockAPIEndpoint())
        
        // Then
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.name, "Test Movie")
    }
    
    func testFetch_whenInvalidJSON_shouldThrowDecodingError() async {
        // Given
        configureSession(
            data: "invalid json".data(using: .utf8)!,
            response: validHTTPResponse()
        )
        
        // When & Then
        await assertThrowsError(expectedError: .decodingFailed) {
            try await networkManager.fetch(endpoint: MockAPIEndpoint()) as TestModel
        }
    }
    
    func testFetch_whenOffline_shouldThrowOfflineError() async {
        // Given
        configureSession(networkStatus: .disconnected)
        
        // When & Then
        await assertThrowsError(expectedError: .offline) {
            try await networkManager.fetch(endpoint: MockAPIEndpoint()) as TestModel
        }
    }
    
    func testFetch_whenHTTPError_shouldThrowServerError() async {
        // Given
        configureSession(
            data: Data(),
            response: validHTTPResponse(statusCode: 500)
        )
        
        // When & Then
        await assertThrowsError(expectedError: .serverError(statusCode: 500)) {
            try await networkManager.fetch(endpoint: MockAPIEndpoint()) as TestModel
        }
    }
    
    func testFetch_whenBadURL_shouldThrowBadURLError() async {
        // Given
        configureSession()
        let invalidEndpoint = MockAPIEndpoint(badURL: true)
        
        // When & Then
        await assertThrowsError(expectedError: .badURL) {
            try await networkManager.fetch(endpoint: invalidEndpoint) as TestModel
        }
    }
}


func assertThrowsError<T>(
    expectedError: AppError,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ operation: () async throws -> T
) async {
    do {
        _ = try await operation()
        XCTFail("Expected to throw, but did not throw", file: file, line: line)
    } catch let error as AppError {
        XCTAssertEqual(error, expectedError, file: file, line: line)
    } catch {
        XCTFail("Unexpected error type: \(error)", file: file, line: line)
    }
}
