import SwiftUI
import UniformTypeIdentifiers

/// A SwiftUI view that displays an interactive image puzzle game.
///
/// The `PuzzleView` allows users to solve a puzzle by dragging and dropping tiles
/// to rearrange them into the correct order. The view displays a grid of image tiles
/// that can be moved by dragging, and provides visual feedback during interactions.
///
/// - Note: The view requires a `PuzzleViewModel` instance to manage the puzzle state and logic.
struct PuzzleView<ViewModel: PuzzleViewModel>: View {
    /// The view model that manages the puzzle state and business logic.
    @StateObject var viewModel: ViewModel

    /// The index of the tile currently being dragged, if any.
    @State var draggedTileIndex: Int?

    /// A flag indicating whether to show the completion alert.
    @State var showCompletionAlert = false

    /// The current drag offset from the initial touch point.
    @State var dragOffset: CGSize = .zero

    /// The current location of the dragged tile on screen.
    @State var dragLocation: CGPoint = .zero

    /// Creates a new puzzle view with the specified view model.
    ///
    /// - Parameter viewModel: The view model instance that manages the puzzle state.
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                // Loading indicator
                loadingIndicator
            } else if viewModel.errorMessage != nil {
                // Error message display
                errorMessageView
            } else if !viewModel.tiles.isEmpty {
                // Puzzle content (progress counter, grid, shuffle button)
                puzzleContent
            }
        }
        .padding()
        .task {
            await viewModel.splitImage()
        }
        .onChange(of: viewModel.correctTilesCount()) { _, _ in
            if viewModel.isPuzzleCompleted() {
                showCompletionAlert = true
            }
        }
        .alert("Puzzle Completed!", isPresented: $showCompletionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Congratulations! You've successfully completed the puzzle!")
        }
    }
}
