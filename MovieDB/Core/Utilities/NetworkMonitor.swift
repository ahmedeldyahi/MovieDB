//
//  NetworkMonitor.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 11/02/2025.
//

import Foundation
import Network

enum NetworkStatus {
    case unknown
    case connected
    case disconnected
}

protocol NetworkMonitorContract {
    var status: NetworkStatus { get }
}

final class NetworkMonitor: NetworkMonitorContract {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    // Use @Published for SwiftUI reactivity
    @Published private(set) var status: NetworkStatus = .unknown
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let newStatus: NetworkStatus = path.status == .satisfied ? .connected : .disconnected
                self?.status = newStatus
            }
        }
        monitor.start(queue: queue)
    }
}
