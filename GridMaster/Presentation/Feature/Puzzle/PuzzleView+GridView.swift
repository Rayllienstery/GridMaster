import SwiftUI

// MARK: - Grid View
extension PuzzleView {
    /// The main grid view that displays all puzzle tiles in a grid layout.
    ///
    /// This computed property creates a `GeometryReader` that calculates the optimal tile size
    /// based on the available space and displays tiles in a `LazyVGrid`. It also shows
    /// a dragged tile overlay when a tile is being moved.
    var gridView: some View {
        GeometryReader { geometry in
            let tileSize =
                min(geometry.size.width, geometry.size.height) / CGFloat(viewModel.gridSize)
            let columns = Array(
                repeating: GridItem(.fixed(tileSize), spacing: 0), count: viewModel.gridSize)
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(Array(viewModel.tiles.enumerated()), id: \.element.hashValue) { index, tile in
                        tileView(tile: tile, index: index, size: tileSize, geometry: geometry)
                    }
                }

                if let draggedIndex = draggedTileIndex, draggedIndex < viewModel.tiles.count {
                    Image(uiImage: viewModel.tiles[draggedIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: tileSize, height: tileSize)
                        .clipped()
                        .opacity(0.8)
                        .position(
                            x: dragLocation.x,
                            y: dragLocation.y
                        )
                        .allowsHitTesting(false)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    /// Creates a view for a single puzzle tile.
    ///
    /// This method renders an individual tile with appropriate styling and gestures.
    /// Tiles in the correct position show haptic feedback when touched, while incorrect
    /// tiles can be dragged to swap positions.
    ///
    /// - Parameters:
    ///   - tile: The image to display for this tile.
    ///   - index: The current index of the tile in the puzzle array.
    ///   - size: The size of the tile in points.
    ///   - geometry: The geometry proxy for calculating positions.
    /// - Returns: A view representing a single puzzle tile.
    @ViewBuilder
    func tileView(tile: UIImage, index: Int, size: CGFloat, geometry: GeometryProxy) -> some View {
        let isCorrect = viewModel.isTileInCorrectPosition(at: index)
        let baseImage = Image(uiImage: tile)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
            .opacity(draggedTileIndex == index ? 0.3 : 1.0)

        let row = index / viewModel.gridSize
        let col = index % viewModel.gridSize
        let centerX = CGFloat(col) * size + size / 2
        let centerY = CGFloat(row) * size + size / 2

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
        } else {
            baseImage
                .frame(width: size, height: size)
                .contentShape(Rectangle())
                .gesture(
                    dragGesture(
                        index: index,
                        size: size,
                        centerX: centerX,
                        centerY: centerY
                    )
                )
        }
    }
}
