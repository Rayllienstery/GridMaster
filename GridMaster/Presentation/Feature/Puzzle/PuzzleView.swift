import SwiftUI

struct PuzzleView<ViewModel: PuzzleViewModel>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Puzzle View")
    }
}
