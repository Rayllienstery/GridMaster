import SwiftUI

// MARK: - Drag Gesture
extension PuzzleView {
    /// Creates a drag gesture for moving puzzle tiles.
    ///
    /// This method creates a `DragGesture` that tracks the user's finger movement
    /// and updates the drag state accordingly. When the drag starts, it sets the
    /// dragged tile index and tracks the translation. When the drag ends, it calls
    /// `handleDragEnd` to process the tile swap.
    ///
    /// - Parameters:
    ///   - index: The index of the tile being dragged.
    ///   - size: The size of each tile in points.
    ///   - centerX: The initial X coordinate of the tile's center.
    ///   - centerY: The initial Y coordinate of the tile's center.
    /// - Returns: A gesture that handles tile dragging interactions.
    func dragGesture(
        index: Int,
        size: CGFloat,
        centerX: CGFloat,
        centerY: CGFloat
    ) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if draggedTileIndex == nil {
                    draggedTileIndex = index
                }
                dragOffset = value.translation
                dragLocation = CGPoint(
                    x: centerX + value.translation.width,
                    y: centerY + value.translation.height
                )
            }
            .onEnded { _ in
                handleDragEnd(size: size)
            }
    }

    /// Handles the completion of a drag gesture and processes tile swapping.
    ///
    /// This method calculates the drop position based on the final drag location,
    /// determines if a valid swap can be performed, and updates the puzzle state accordingly.
    /// It provides haptic feedback when attempting to drop on a correctly positioned tile.
    ///
    /// - Parameter size: The size of each tile in points, used to calculate grid positions.
    func handleDragEnd(size: CGFloat) {
        guard let draggedIndex = draggedTileIndex else { return }
        let dropRow = Int(dragLocation.y / size)
        let dropCol = Int(dragLocation.x / size)
        let dropIndex = dropRow * viewModel.gridSize + dropCol

        if dropIndex >= 0 && dropIndex < viewModel.tiles.count &&
           dropIndex != draggedIndex &&
           !viewModel.isTileInCorrectPosition(at: dropIndex) {
            Task { @MainActor in
                viewModel.swapTiles(from: draggedIndex, to: dropIndex)
            }
        } else if dropIndex >= 0 && dropIndex < viewModel.tiles.count &&
                  viewModel.isTileInCorrectPosition(at: dropIndex) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }

        draggedTileIndex = nil
        dragOffset = .zero
    }
}
