import SwiftUI

struct HomeView<ViewModel: HomeViewModel>: View {
    @StateObject private var viewModel: ViewModel

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
                // TODO: Add logic
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isNetworkAvailable)

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
