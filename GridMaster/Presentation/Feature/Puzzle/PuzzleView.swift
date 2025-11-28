import SwiftUI
import UniformTypeIdentifiers

struct PuzzleView<ViewModel: PuzzleViewModel>: View {
    @StateObject private var viewModel: ViewModel
    @State private var draggedTileIndex: Int?
    @State private var showCompletionAlert = false

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.tiles.isEmpty {
                Text("Correct: \(viewModel.correctTilesCount())/\(viewModel.tiles.count)")
                    .font(.headline)

                gridView

                Button("Shuffle") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.shuffleTiles()
                    }
                }
                .buttonStyle(.borderedProminent)
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

    private var gridView: some View {
        GeometryReader { geometry in
            let tileSize =
                min(geometry.size.width, geometry.size.height) / CGFloat(viewModel.gridSize)
            let columns = Array(
                repeating: GridItem(.fixed(tileSize), spacing: 0), count: viewModel.gridSize)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(Array(viewModel.tiles.enumerated()), id: \.element.hashValue) { index, tile in
                    tileView(tile: tile, index: index, size: tileSize)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func tileView(tile: UIImage, index: Int, size: CGFloat) -> some View {
        let isCorrect = viewModel.isTileInCorrectPosition(at: index)
        let baseImage = Image(uiImage: tile)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()

            if isCorrect {
                baseImage
                    .frame(width: size, height: size)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }
                    )
                    .onDrop(
                        of: [UTType.plainText],
                        delegate: TileDropDelegate(
                            destinationIndex: index,
                            draggedTileIndex: $draggedTileIndex,
                            isDestinationLocked: true,
                            onDrop: { _ in }
                        ))
            } else {
                baseImage
                    .frame(width: size, height: size)
                    .onDrag {
                        draggedTileIndex = index
                        return NSItemProvider(object: String(index) as NSString)
                    }
                    .onDrop(
                        of: [UTType.plainText],
                        delegate: TileDropDelegate(
                            destinationIndex: index,
                            draggedTileIndex: $draggedTileIndex,
                            isDestinationLocked: false,
                            onDrop: { sourceIndex in
                                Task { @MainActor in
                                    viewModel.swapTiles(from: sourceIndex, to: index)
                                    draggedTileIndex = nil
                                }
                            }
                        ))
            }
    }
}

private struct TileDropDelegate: DropDelegate {
    let destinationIndex: Int
    @Binding var draggedTileIndex: Int?
    let isDestinationLocked: Bool
    let onDrop: (Int) -> Void

    func performDrop(info: DropInfo) -> Bool {
        guard !isDestinationLocked else {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            draggedTileIndex = nil
            return false
        }

        guard let draggedIndex = draggedTileIndex,
            draggedIndex != destinationIndex
        else {
            draggedTileIndex = nil
            return false
        }

        onDrop(draggedIndex)
        draggedTileIndex = nil
        return true
    }
}
