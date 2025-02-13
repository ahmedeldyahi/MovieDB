//
//  ViewState.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 12/02/2025.
//

import Foundation
enum ViewState<T: Equatable>: Equatable {
//    case empty
    case loading
    case success(T)
    case error(ErrorInfo)
    
}


struct ErrorInfo: Equatable {
    let message: String
    let retryable: Bool
    let  iconName: String
    init(message: String,
         retryable: Bool = true,
         iconName: String = "exclamationmark.triangle"

    ) {
        self.message = message
        self.retryable = retryable
        self.iconName = iconName
    }
}
