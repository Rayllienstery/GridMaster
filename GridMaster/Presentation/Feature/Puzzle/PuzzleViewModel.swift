import Foundation
import UIKit
import Combine

protocol PuzzleViewModel: Observable, ObservableObject, AnyObject {
    var sourceImage: UIImage? { get }
    var tiles: [UIImage] { get }
    var correctTileHashes: [Int] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    var gridSize: Int { get }

    @MainActor func splitImage() async
    @MainActor func shuffleTiles()
    @MainActor func swapTiles(from sourceIndex: Int, to destinationIndex: Int)
    func isTileInCorrectPosition(at index: Int) -> Bool
    func correctTilesCount() -> Int
    func isPuzzleCompleted() -> Bool
}

@Observable
final class PuzzleViewModelImpl: PuzzleViewModel {
    private let splitImageUseCase: SplitImageIntoGridUseCase

    var sourceImage: UIImage?
    var tiles: [UIImage] = []
    var correctTileHashes: [Int] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var gridSize: Int

    init(sourceImage: UIImage?, splitImageUseCase: SplitImageIntoGridUseCase, gridSize: Int) {
        self.sourceImage = sourceImage
        self.splitImageUseCase = splitImageUseCase
        self.gridSize = gridSize
    }

    @MainActor
    func splitImage() async {
        guard let image = sourceImage else {
            errorMessage = "No source image available"
            return
        }

        isLoading = true
        errorMessage = nil
        tiles = []

        do {
            tiles = try splitImageUseCase.execute(image: image)
            // Store correct tile hashes for each position
            correctTileHashes = tiles.map { $0.hashValue }
            // Shuffle tiles for the puzzle
            shuffleTiles()
        } catch let error as PuzzleError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Failed to split image"
        }

        isLoading = false
    }

    @MainActor
    func shuffleTiles() {
        tiles.shuffle()
    }

    @MainActor
    func swapTiles(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex,
              sourceIndex >= 0 && sourceIndex < tiles.count,
              destinationIndex >= 0 && destinationIndex < tiles.count else {
            return
        }

        tiles.swapAt(sourceIndex, destinationIndex)
    }

    func isTileInCorrectPosition(at index: Int) -> Bool {
        guard index >= 0 && index < tiles.count && index < correctTileHashes.count else {
            return false
        }
        // Compare current tile hash with expected hash for this position
        return tiles[index].hashValue == correctTileHashes[index]
    }

    func correctTilesCount() -> Int {
        guard tiles.count == correctTileHashes.count else {
            return 0
        }
        return (0..<tiles.count).filter { isTileInCorrectPosition(at: $0) }.count
    }

    func isPuzzleCompleted() -> Bool {
        guard tiles.count == correctTileHashes.count, tiles.count > 0 else {
            return false
        }
        return correctTilesCount() == tiles.count
    }
}
