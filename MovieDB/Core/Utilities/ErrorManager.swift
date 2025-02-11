//
//  ErrorManager.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//


import SwiftUI
import Combine
protocol ErrorManagerContract: AnyObject {
    var currentError: AppError? { get }
    func show(_ error: AppError, duration: TimeInterval)
    func dismiss()
    func dismissAll()
}

final class ErrorManager: ObservableObject, ErrorManagerContract {
    static let shared = ErrorManager()
    
    @Published private var errorQueue: [AppError] = []
    @Published var currentError: AppError? = nil
    private var dismissTimer: Timer?
    
    private init() {}
    
    func show(_ error: AppError, duration: TimeInterval = 3.0) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.errorQueue.append(error)
            self.processNextError(duration: duration)
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.currentError = nil
            self?.dismissTimer?.invalidate()
            self?.processNextError()
        }
    }
    
    func dismissAll() {
        DispatchQueue.main.async { [weak self] in
            self?.errorQueue.removeAll()
            self?.dismiss()
        }
    }
    
    private func processNextError(duration: TimeInterval = 3.0) {
        guard currentError == nil, !errorQueue.isEmpty else { return }
        
        currentError = errorQueue.removeFirst()
        scheduleAutoDismiss(after: duration)
    }
    
    private func scheduleAutoDismiss(after duration: TimeInterval) {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(
            withTimeInterval: duration,
            repeats: false
        ) { [weak self] _ in
            self?.dismiss()
        }
    }
}

struct ToastView: View {
    let errorDescription: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            
            Text(errorDescription)
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.red.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct GlobalErrorToastModifier: ViewModifier {
    @ObservedObject var errorManager: ErrorManager
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if let error = errorManager.currentError {
                ToastView(
                    errorDescription: error.errorDescription,
                    onDismiss: errorManager.dismiss
                )
                .zIndex(1)
            }
        }
        .animation(
            .spring(response: 0.3, dampingFraction: 0.5),
            value: errorManager.currentError?.errorDescription
        )
    }
}

extension View {
    func globalErrorToast(
        manager: ErrorManager = .shared,
        backgroundColor: Color = .red,
        duration: TimeInterval = 3.0
    ) -> some View {
        self.modifier(GlobalErrorToastModifier(
            errorManager: manager
        ))
    }
}
