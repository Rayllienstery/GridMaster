import Foundation
import Combine

/// Protocol for monitoring network connectivity status
protocol NetworkMonitorProtocol {
    /// Publisher that emits network connectivity status changes
    /// - Returns: Publisher that emits `true` when network is available, `false` otherwise
    var isConnected: AnyPublisher<Bool, Never> { get }

    /// Current network connectivity status
    /// - Returns: `true` if network is currently available, `false` otherwise
    var currentStatus: Bool { get }
}
