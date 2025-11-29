import SwiftUI
import TMNavigation

// MARK: - View Components
extension HomeView {
    var titleView: some View {
        Text("Welcome to GridMaster")
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    var gridSizePicker: some View {
        VStack(spacing: 16) {
            Text("Grid Size")
                .font(.headline)

            Picker("Grid Size", selection: $viewModel.selectedGridSize) {
                ForEach(2...5, id: \.self) { size in
                    Text("\(size)x\(size)").tag(size)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var networkStatusSection: some View {
        Group {
            if !viewModel.isNetworkAvailable {
                VStack(spacing: 16) {
                    networkUnavailableMessage
                    localAssetsGrid
                }
            }
        }
    }

    var networkUnavailableMessage: some View {
        Text("No internet connection")
            .font(.subheadline)
            .foregroundColor(.red)
    }

    var loadImageButton: some View {
        Button("Get Image from Picsum") {
            Task {
                await viewModel.loadImage(coordinator: coordinator)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.isNetworkAvailable || viewModel.isLoading)
    }

    var loadingIndicator: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }

    var errorMessageView: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
    }

    var localAssetsGrid: some View {
        VStack(spacing: 16) {
            Text("Select Local Asset")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(["asset.1", "asset.2", "asset.3"], id: \.self) { assetName in
                    LocalAssetButton(assetName: assetName) {
                        viewModel.selectLocalAsset(assetName, coordinator: coordinator)
                    }
                }
            }
        }
    }
}
