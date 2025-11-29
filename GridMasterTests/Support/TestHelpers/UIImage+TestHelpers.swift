import UIKit

/// Test helper extensions for `UIImage` to simplify test image creation.
///
/// These extensions were created to provide convenient methods for generating
/// test images in unit tests without requiring external image files or network requests.
/// They allow tests to:
/// - Create images with specific dimensions and colors
/// - Generate images suitable for grid splitting tests
/// - Ensure consistent test data across different test runs
/// - Avoid dependencies on external resources
extension UIImage {
    /// Creates a test image with specified size and color.
    ///
    /// This method generates a simple solid-color image useful for basic image
    /// processing tests. It's particularly useful when you need a predictable
    /// image for testing without loading external resources.
    ///
    /// - Parameters:
    ///   - size: The size of the image in points. Defaults to 100x100.
    ///   - color: The fill color for the image. Defaults to red.
    /// - Returns: A new `UIImage` instance with the specified size and color.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let testImage = UIImage.testImage(size: CGSize(width: 200, height: 200), color: .blue)
    /// ```
    static func testImage(size: CGSize = CGSize(width: 100, height: 100), color: UIColor = .red) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    /// Creates a test image designed for grid splitting tests.
    ///
    /// This method generates a square image divided into a grid of colored tiles.
    /// Each tile has a unique hue based on its position, making it easy to verify
    /// that image splitting works correctly. The tiles are arranged in a grid
    /// pattern matching the specified `gridSize`.
    ///
    /// - Parameters:
    ///   - gridSize: The number of rows and columns in the grid (e.g., 3 for a 3x3 grid).
    ///   - size: The total size of the image in points. Defaults to 300.
    /// - Returns: A new `UIImage` instance with a grid pattern suitable for splitting tests.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let gridImage = UIImage.testImageForGrid(gridSize: 3, size: 300)
    /// // Creates a 300x300 image with a 3x3 grid of 9 uniquely colored tiles
    /// ```
    ///
    /// ## How It Works
    ///
    /// The image is divided into `gridSize × gridSize` tiles. Each tile's color
    /// is determined by its position using HSL color space, ensuring each tile
    /// is visually distinct. This makes it easy to verify that tiles are split
    /// and reassembled correctly in puzzle-related tests.
    static func testImageForGrid(gridSize: Int, size: Int = 300) -> UIImage {
        let imageSize = CGSize(width: size, height: size)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { context in
            let tileSize = CGFloat(size) / CGFloat(gridSize)
            for row in 0..<gridSize {
                for col in 0..<gridSize {
                    let hue = CGFloat((row * gridSize + col)) / CGFloat(gridSize * gridSize)
                    let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    color.setFill()
                    let rect = CGRect(
                        x: CGFloat(col) * tileSize,
                        y: CGFloat(row) * tileSize,
                        width: tileSize,
                        height: tileSize
                    )
                    context.fill(rect)
                }
            }
        }
    }
}
