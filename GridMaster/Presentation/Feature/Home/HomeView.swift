import SwiftUI
import TMNavigation

struct HomeView<ViewModel: HomeViewModel>: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.coordinator) var coordinator: TMCoordinator<AppWaypoint>

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("Welcome to GridMaster")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                Text("Grid Size")
                    .font(.headline)

                Picker("Grid Size", selection: $viewModel.selectedGridSize) {
                    Text("3x3").tag(3)
                    Text("4x4").tag(4)
                    Text("5x5").tag(5)
                }
                .pickerStyle(.segmented)
            }

            if !viewModel.isNetworkAvailable {
                Text("No internet connection")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            Button("Get Image from Picsum") {
                Task {
                    await viewModel.loadImage(coordinator: coordinator)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isNetworkAvailable || viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            if !viewModel.isNetworkAvailable {
                Button("Select Local Asset") {
                    // TODO: Add logic
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
