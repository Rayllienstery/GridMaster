import Foundation
@testable import GridMaster

/// Mock implementation of `ImageRepositoryProtocol` for unit testing.
///
/// This mock was created to isolate components during testing by replacing the real
/// `ImageRepositoryImpl` that makes actual network requests. It allows tests to:
/// - Control the behavior of image loading without network dependencies
/// - Simulate success and failure scenarios
/// - Verify that repository methods are called with expected parameters
/// - Test error handling paths without relying on network conditions
///
/// ## Usage
///
/// ```swift
/// let mockRepository = MockImageRepository()
/// mockRepository.loadImageResult = .success(imageData)
/// let useCase = PicsumImageFetcherUseCase(repository: mockRepository)
/// ```
///
/// ## Testing Error Scenarios
///
/// ```swift
/// mockRepository.loadImageResult = .failure(ImageError.networkError)
/// ```
final class MockImageRepository: ImageRepositoryProtocol {
    /// The result to return when `loadImage()` is called.
    ///
    /// Set this property before calling `loadImage()` to control the mock's behavior.
    /// Defaults to `.success(Data())`.
    var loadImageResult: Result<Data, Error> = .success(Data())

    /// The number of times `loadImage()` has been called.
    ///
    /// Use this property to verify that the repository method was called
    /// the expected number of times in your tests.
    var loadImageCallCount = 0

    /// Simulates loading an image from a remote source.
    ///
    /// - Returns: The data specified in `loadImageResult` if successful.
    /// - Throws: The error specified in `loadImageResult` if failed.
    func loadImage() async throws -> Data {
        loadImageCallCount += 1
        switch loadImageResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
