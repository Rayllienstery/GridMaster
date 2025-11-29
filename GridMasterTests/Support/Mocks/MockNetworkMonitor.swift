import Foundation
import Combine
@testable import GridMaster

/// Mock implementation of `NetworkMonitorProtocol` for unit testing.
///
/// This mock was created to test network-dependent functionality without relying on
/// actual network connectivity. It allows tests to:
/// - Simulate network availability and unavailability scenarios
/// - Test how components react to network status changes
/// - Verify network-dependent logic without requiring actual network conditions
/// - Control network state transitions during test execution
///
/// ## Usage
///
/// ```swift
/// let mockMonitor = MockNetworkMonitor(currentStatus: true)
/// let viewModel = HomeViewModelImpl(
///     imageFetcher: imageFetcher,
///     networkMonitor: mockMonitor
/// )
/// ```
///
/// ## Testing Network Status Changes
///
/// ```swift
/// mockMonitor.updateConnectionStatus(false)
/// // Wait for Combine to process
/// try? await Task.sleep(nanoseconds: 100_000_000)
/// XCTAssertFalse(viewModel.isNetworkAvailable)
/// ```
final class MockNetworkMonitor: NetworkMonitorProtocol {
    private let _isConnected: CurrentValueSubject<Bool, Never>
    private let _currentStatus: Bool

    /// Publisher that emits network connection status changes.
    ///
    /// Components can subscribe to this publisher to react to network status changes.
    var isConnected: AnyPublisher<Bool, Never> {
        _isConnected.eraseToAnyPublisher()
    }

    /// The current network connection status.
    ///
    /// Returns the initial status set during initialization.
    var currentStatus: Bool {
        _currentStatus
    }

    /// Creates a mock network monitor with the specified initial connection status.
    ///
    /// - Parameter currentStatus: The initial network connection status. Defaults to `true`.
    init(currentStatus: Bool = true) {
        _currentStatus = currentStatus
        _isConnected = CurrentValueSubject<Bool, Never>(currentStatus)
    }

    /// Updates the network connection status and notifies subscribers.
    ///
    /// Call this method during tests to simulate network status changes.
    /// All subscribers to `isConnected` will receive the updated status.
    ///
    /// - Parameter isConnected: The new network connection status.
    func updateConnectionStatus(_ isConnected: Bool) {
        _isConnected.send(isConnected)
    }
}
