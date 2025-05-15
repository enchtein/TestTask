//
//  NetworkMonitor.swift
//  TestTask
//
//  Created by Дмитрий Хероим on 15.05.2025.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
  static let shared = NetworkMonitor()
  @Published var isConnected: Bool = true
  
  private var monitor: NWPathMonitor?
  
  /// The dispatch queue on which the network monitor runs.
  private var queue = DispatchQueue.global(qos: .background)
  
  private init() {
    startMonitoring()
  }
  
  /// Begins network monitoring on a background queue.
  private func startMonitoring() {
    monitor = NWPathMonitor()
    
    monitor?.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.isConnected = (path.status == .satisfied)
      }
    }
    monitor?.start(queue: queue)
  }
  
  /// Stops the network monitor and cleans up resources.
  private func stopMonitoring() {
    monitor?.cancel()
    monitor = nil
  }
  
  deinit {
    stopMonitoring()
  }
}
