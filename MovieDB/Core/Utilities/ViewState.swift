//
//  ViewState.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation
enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case error(ErrorInfo)
    
    struct ErrorInfo: Equatable {
        let message: String
        let retryable: Bool
        let code: Int?
        
        init(message: String, retryable: Bool = true, code: Int? = nil) {
            self.message = message
            self.retryable = retryable
            self.code = code
        }
    }
}


extension ViewState {
    var isLoading: Bool {
        if case .loading = self { true } else { false }
    }
    
    var data: T? {
        if case .success(let data) = self { data } else { nil }
    }
    
    var error: ErrorInfo? {
        if case .error(let error) = self { error } else { nil }
    }
}


extension ViewState {
    mutating func startLoading() {
        self = .loading
    }
    
    mutating func handleResult(_ result: Result<T, AppError>) {
        switch result {
        case .success(let data):
            self = .success(data)
        case .failure(let error):
            self = .error(.init(
                message: error.errorDescription,
                retryable: isRetryable(error)
            ))
        }
    }
    
    private func isRetryable(_ error: Error) -> Bool {
        // Add custom retry logic
        true
    }
}
