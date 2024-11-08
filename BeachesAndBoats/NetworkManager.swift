//
//  NetworkManager.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/10/2024.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                
                // Handle connectivity changes here
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
