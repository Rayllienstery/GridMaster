import SwiftUI
import TMNavigation

struct HomeView<ViewModel: HomeViewModel>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator: TMCoordinator<AppWaypoint>

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 32) {
            // App title header
            titleView

            // Grid size selection picker (2x2, 3x3, 4x4, 5x5)
            gridSizePicker

            // Network status message and local assets grid (shown when offline)
            networkStatusSection

            // Button to load image from Picsum API
            loadImageButton

            // Loading progress indicator
            loadingIndicator

            // Error message display (if any)
            errorMessageView
        }
        .padding()
    }
}
