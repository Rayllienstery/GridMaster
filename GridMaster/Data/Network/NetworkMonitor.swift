import Foundation
import Network
import Combine

/// Implementation of NetworkMonitorProtocol using NWPathMonitor
///
/// This class uses `NWPathMonitor` to track network connectivity and provides
/// a Combine publisher that emits updates whenever the network status changes.
///
/// ## Example
///
/// ```swift
/// let monitor = NetworkMonitor()
///
/// monitor.isConnected
///     .sink { isConnected in
///         print("Network status: \(isConnected)")
///     }
/// ```
final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let subject = CurrentValueSubject<Bool, Never>(false)

    /// Publisher that emits network connectivity status changes
    ///
    /// Subscribe to this publisher to receive updates whenever the network
    /// connectivity status changes. The publisher emits `true` when network
    /// becomes available and `false` when it becomes unavailable.
    ///
    /// - Returns: Publisher that emits `Bool` values representing network connectivity status
    var isConnected: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    /// Current network connectivity status
    ///
    /// This property provides synchronous access to the current network status
    /// without requiring a subscription to the publisher.
    ///
    /// - Returns: `true` if network is currently available, `false` otherwise
    var currentStatus: Bool {
        monitor.currentPath.status == .satisfied
    }

    /// Initializes a new network monitor
    ///
    /// The monitor starts tracking network connectivity immediately upon initialization
    /// and sets the initial status in the publisher.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.subject.send(isConnected)
        }
        monitor.start(queue: queue)

        // Set initial status
        subject.send(monitor.currentPath.status == .satisfied)
    }
}
