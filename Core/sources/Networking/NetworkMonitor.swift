//
//  NetworkMonitor.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 05/09/25.
//
import Foundation
import Network

public protocol NetworkMonitorProtocol {
    var isOnline: Bool { get }
    var statusDidChange: ((Bool) -> Void)? { get set }
    func startMonitoring()
    func stopMonitoring()
}
public final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    public var statusDidChange: ((Bool) -> Void)?
    private(set) public var isOnline: Bool = false {
        didSet {
            if oldValue != isOnline {
                print(isOnline ? "🌐 Online" : "📴 Offline")
                statusDidChange?(isOnline)
            }
        }
    }

    public init() {}

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isOnline = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)

        // ✅ Print + trigger callback immediately
        DispatchQueue.main.async {
            self.isOnline = (self.monitor.currentPath.status == .satisfied)
            print("🔍 Initial network status: \(self.isOnline ? "Online" : "Offline")")
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}

