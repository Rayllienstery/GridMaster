import SwiftUI
import UniformTypeIdentifiers

struct PuzzleView<ViewModel: PuzzleViewModel>: View {
    @StateObject private var viewModel: ViewModel
    @State private var draggedTileIndex: Int?

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
                gridView
            }
        }
        .padding()
        .task {
            await viewModel.splitImage()
        }
    }

    private var gridView: some View {
        GeometryReader { geometry in
            let tileSize = min(geometry.size.width, geometry.size.height) / CGFloat(viewModel.gridSize)
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(tileSize), spacing: 0), count: viewModel.gridSize), spacing: 0) {
                ForEach(Array(viewModel.tiles.enumerated()), id: \.offset) { index, tile in
                    tileView(tile: tile, index: index, size: tileSize)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func tileView(tile: UIImage, index: Int, size: CGFloat) -> some View {
        Image(uiImage: tile)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
            .onDrag {
                draggedTileIndex = index
                return NSItemProvider(object: String(index) as NSString)
            }
            .onDrop(of: [UTType.plainText], delegate: TileDropDelegate(
                destinationIndex: index,
                draggedTileIndex: $draggedTileIndex,
                onDrop: { sourceIndex in
                    Task { @MainActor in
                        viewModel.swapTiles(from: sourceIndex, to: index)
                        draggedTileIndex = nil
                    }
                }
            ))
    }
}

private struct TileDropDelegate: DropDelegate {
    let destinationIndex: Int
    @Binding var draggedTileIndex: Int?
    let onDrop: (Int) -> Void

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedIndex = draggedTileIndex,
              draggedIndex != destinationIndex else {
            draggedTileIndex = nil
            return false
        }

        onDrop(draggedIndex)
        draggedTileIndex = nil
        return true
    }
}
