//
//  AppErrorTests.swift
//  MovieDBTests
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import Foundation

import XCTest
@testable import MovieDB

final class AppErrorTests: XCTestCase {
    
    // MARK: - Error Description Tests
    func testErrorDescription_forEachCase_shouldMatchExpectedMessage() {
        // Given & When & Then
        XCTAssertEqual(AppError.rateLimitExceeded.errorDescription, "Rate limit exceeded. Please try again later.")
        XCTAssertEqual(AppError.invalidAPIKey.errorDescription, "Invalid API key. Contact support.")
        XCTAssertEqual(AppError.badURL.errorDescription, "Invalid URL.")
        XCTAssertEqual(AppError.offline.errorDescription, "The internet connection appears offline.")
        XCTAssertEqual(AppError.decodingFailed.errorDescription, "Failed to parse server response.")
        XCTAssertEqual(AppError.serverError(statusCode: 500).errorDescription, "Server error. Try again later.")
        XCTAssertEqual(AppError.clientError(statusCode: 404).errorDescription, "Resource not found.")
        XCTAssertEqual(AppError.emptyData.errorDescription, "No data available.")
        XCTAssertEqual(AppError.unknown(message: "Something went wrong").errorDescription, "Something went wrong")
    }
    
    // MARK: - Equatable Tests
    func testAppErrorEquality_sameCases_shouldBeEqual() {
        // Given & When & Then
        XCTAssertEqual(AppError.rateLimitExceeded, AppError.rateLimitExceeded)
        XCTAssertEqual(AppError.invalidAPIKey, AppError.invalidAPIKey)
        XCTAssertEqual(AppError.badURL, AppError.badURL)
        XCTAssertEqual(AppError.offline, AppError.offline)
        XCTAssertEqual(AppError.decodingFailed, AppError.decodingFailed)
        XCTAssertEqual(AppError.emptyData, AppError.emptyData)
        XCTAssertEqual(AppError.serverError(statusCode: 500), AppError.serverError(statusCode: 500))
        XCTAssertEqual(AppError.clientError(statusCode: 404), AppError.clientError(statusCode: 404))
        XCTAssertEqual(AppError.unknown(statusCode: 123, message: "Error"), AppError.unknown(statusCode: 123, message: "Error"))
    }

    func testAppErrorEquality_differentCases_shouldNotBeEqual() {
        // Given & When & Then
        XCTAssertNotEqual(AppError.rateLimitExceeded, AppError.invalidAPIKey)
        XCTAssertNotEqual(AppError.serverError(statusCode: 500), AppError.serverError(statusCode: 501))
        XCTAssertNotEqual(AppError.clientError(statusCode: 400), AppError.clientError(statusCode: 404))
        XCTAssertNotEqual(AppError.unknown(statusCode: 123, message: "Error A"), AppError.unknown(statusCode: 123, message: "Error B"))
        XCTAssertNotEqual(AppError.unknown(statusCode: nil, message: "Unknown"), AppError.unknown(statusCode: 400, message: "Unknown"))
    }

    // MARK: - HTTP Status Code Validation Tests
    
    func testValidateStatusCode_whenClientError_shouldThrowClientError() {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!

        // When & Then
        XCTAssertThrowsError(try response.validateStatusCode()) { error in
            XCTAssertEqual(error as? AppError, AppError.clientError(statusCode: 404))
        }
    }

    func testValidateStatusCode_whenServerError_shouldThrowServerError() {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

        // When & Then
        XCTAssertThrowsError(try response.validateStatusCode()) { error in
            XCTAssertEqual(error as? AppError, AppError.serverError(statusCode: 500))
        }
    }

    func testValidateStatusCode_whenUnauthorized_shouldThrowInvalidAPIKeyError() {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!

        // When & Then
        XCTAssertThrowsError(try response.validateStatusCode()) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidAPIKey)
        }
    }

    func testValidateStatusCode_whenTooManyRequests_shouldThrowRateLimitExceededError() {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 429, httpVersion: nil, headerFields: nil)!

        // When & Then
        XCTAssertThrowsError(try response.validateStatusCode()) { error in
            XCTAssertEqual(error as? AppError, AppError.rateLimitExceeded)
        }
    }

    func testValidateStatusCode_whenSuccess_shouldNotThrowError() {
        // Given
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!

        // When & Then
        XCTAssertNoThrow(try response.validateStatusCode())
    }
}
