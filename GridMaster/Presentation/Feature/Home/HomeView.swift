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

            if !viewModel.isNetworkAvailable {
                Text("No internet connection")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            Button("Get Image from Picsum") {
                Task {
                    await viewModel.loadImage()
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
        .onChange(of: viewModel.loadedImage) { _, newImage in
            if let image = newImage {
                coordinator.append(.puzzle(image: image))
            }
        }
    }
}
