//
//  ErrorView.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorInfo: ErrorInfo
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: errorInfo.iconName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 48))
                .accessibilityHidden(true)
            
            VStack(spacing: 8) {
                Text(errorInfo.message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
            }
            
            if errorInfo.retryable {
                Button(action: {
                    retryAction?()
                }) {
                    Label("Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            }
        }
        .padding()
        .frame(maxWidth: 400)
        .background(.thinMaterial)
        .cornerRadius(16)
        .padding()
        .accessibilityElement(children: .combine)
    }
}


#Preview {
    ErrorView(errorInfo: .init(message: AppError.offline.errorDescription)) {
        
    }
}
