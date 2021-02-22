//
//  NetworkMonitor.swift
//  MovieOmdbApi
//
//  Created by Onur Başdaş on 22.02.2021.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    private init(){
        
        monitor = NWPathMonitor()
    }
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.connectionType = .wifi
            self?.getConnectionType(path)
        }
    }
    public func stopMonitoring(){
        monitor.cancel()
    }
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        }else{
            connectionType = .unknown
        }
    }
}
