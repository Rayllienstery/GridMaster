import Foundation
import UIKit

final class SplitImageIntoGridUseCase {
    private let gridSize: Int

    init(gridSize: Int) {
        self.gridSize = gridSize
    }

    func execute(image: UIImage) throws -> [UIImage] {
        guard let cgImage = image.cgImage else {
            throw PuzzleError.invalidImage
        }

        let tileWidth = cgImage.width / gridSize
        let tileHeight = cgImage.height / gridSize

        var tiles: [UIImage] = []

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let tileX = col * tileWidth
                let tileY = row * tileHeight

                guard let tileCGImage = cgImage.cropping(to: CGRect(
                    x: tileX,
                    y: tileY,
                    width: tileWidth,
                    height: tileHeight
                )) else {
                    throw PuzzleError.imageSplitFailed
                }

                let tileImage = UIImage(cgImage: tileCGImage, scale: image.scale, orientation: image.imageOrientation)
                tiles.append(tileImage)
            }
        }

        return tiles
    }
}
