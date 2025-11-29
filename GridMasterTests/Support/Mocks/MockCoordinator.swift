import Foundation
import SwiftUI
import TMNavigation
@testable import GridMaster

/// Mock wrapper for `TMCoordinator` to enable navigation testing.
///
/// This mock was created because `TMCoordinator` is a `final` class from the
/// `TMNavigation` framework, making it impossible to subclass or create a traditional mock.
/// Instead, this wrapper uses composition to track navigation calls by monitoring
/// the `navigationPath` property.
///
/// It allows tests to:
/// - Verify that navigation occurs when expected
/// - Count the number of waypoints appended during test execution
/// - Test navigation-dependent logic without requiring a full UI setup
/// - Isolate view model navigation logic from the actual navigation framework
///
/// ## Usage
///
/// ```swift
/// let mockCoordinator = MockCoordinator()
/// await viewModel.loadImage(coordinator: mockCoordinator.asTMCoordinator())
/// XCTAssertEqual(mockCoordinator.appendCallCount, 1)
/// ```
///
/// ## How It Works
///
/// The mock wraps a real `TMCoordinator` instance and tracks changes to its
/// `navigationPath`. When a waypoint is appended via `coordinator.append()`,
/// the path count increases, which is tracked by `appendCallCount`.
@MainActor
final class MockCoordinator {
    private let realCoordinator: TMCoordinator<AppWaypoint>
    private var initialPathCount: Int = 0

    /// Creates a new mock coordinator instance.
    ///
    /// Initializes a real `TMCoordinator` and records its initial path count
    /// to track subsequent navigation changes.
    init() {
        realCoordinator = TMCoordinator<AppWaypoint>()
        initialPathCount = realCoordinator.navigationPath.count
    }

    /// Returns the real `TMCoordinator` instance for use in view models.
    ///
    /// View models require a real `TMCoordinator` instance to function correctly.
    /// This method provides access to the wrapped coordinator while allowing
    /// the mock to track navigation calls.
    ///
    /// - Returns: The real `TMCoordinator<AppWaypoint>` instance.
    func asTMCoordinator() -> TMCoordinator<AppWaypoint> {
        return realCoordinator
    }

    /// Returns the number of waypoints appended since initialization.
    ///
    /// This property calculates the difference between the current `navigationPath`
    /// count and the initial count, effectively tracking how many waypoints
    /// have been appended during test execution.
    ///
    /// Use this to verify that navigation occurred as expected:
    /// ```swift
    /// XCTAssertEqual(mockCoordinator.appendCallCount, 1)
    /// ```
    var appendCallCount: Int {
        realCoordinator.navigationPath.count - initialPathCount
    }
}
