//
//  NetworkMonitor.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

/*
 monitor network changes
 */

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    
    var isReachable: Bool { status == .satisfied }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = {[weak self] path in
            self?.status = path.status
            print("connected: \(path.status == .satisfied)")
            DispatchQueue.main.async {
                NotificationCenter.default.post(InAppNotification.connectivityDidChange.notification)
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
}
