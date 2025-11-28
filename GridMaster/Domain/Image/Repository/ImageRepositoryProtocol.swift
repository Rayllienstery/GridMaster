import Foundation

/// Protocol for image repository
protocol ImageRepositoryProtocol {
    /// Loads image from remote URL
    /// - Returns: Image data
    /// - Throws: Error if loading fails
    func loadImage() async throws -> Data
}
