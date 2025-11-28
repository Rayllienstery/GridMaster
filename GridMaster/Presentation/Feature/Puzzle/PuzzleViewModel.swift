import Foundation
import UIKit
import Combine

protocol PuzzleViewModel: Observable, ObservableObject, AnyObject {
    var sourceImage: UIImage? { get }
    var tiles: [UIImage] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    var gridSize: Int { get }

    @MainActor func splitImage() async
    @MainActor func swapTiles(from sourceIndex: Int, to destinationIndex: Int)
}

@Observable
final class PuzzleViewModelImpl: PuzzleViewModel {
    private let splitImageUseCase: SplitImageIntoGridUseCase

    var sourceImage: UIImage?
    var tiles: [UIImage] = []
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
        } catch let error as PuzzleError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Failed to split image"
        }

        isLoading = false
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
}
