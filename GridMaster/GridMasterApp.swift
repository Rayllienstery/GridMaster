import SwiftUI
import TMNavigation

@main
struct GridMasterApp: App {
    @Bindable var coordinator = TMCoordinator<AppWaypoint>()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                HomeFactory().impl()
                .navigationDestination(for: TMNavigationDestination.self) { destination in
                  destination.view
                }
                .environment(\.coordinator, coordinator)
            }
        }
    }
}
