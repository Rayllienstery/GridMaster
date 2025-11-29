import SwiftUI

// MARK: - View Components
extension PuzzleView {
    var loadingIndicator: some View {
        ProgressView()
            .padding()
    }

    var errorMessageView: some View {
        Text(viewModel.errorMessage ?? "")
            .foregroundColor(.red)
            .padding()
    }

    var puzzleContent: some View {
        VStack(spacing: 16) {
            progressCounter
            gridView
            shuffleButton
        }
    }

    var progressCounter: some View {
        Text("Correct: \(viewModel.correctTilesCount())/\(viewModel.tiles.count)")
            .font(.headline)
    }

    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 0.5)) {
                viewModel.shuffleTiles()
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
