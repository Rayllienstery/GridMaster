import XCTest
@testable import GridMaster

@MainActor
final class PicsumImageFetcherUseCaseTests: XCTestCase {
    var mockRepository: MockImageRepository!
    var useCase: PicsumImageFetcherUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockImageRepository()
        useCase = PicsumImageFetcherUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func testShouldReturnImageDataWhenRepositoryReturnsValidData() async throws {
        // Given
        let expectedData = Data("test image data".utf8)
        mockRepository.loadImageResult = .success(expectedData)

        // When
        let result = try await useCase.execute()

        // Then
        XCTAssertEqual(result, expectedData)
        XCTAssertEqual(mockRepository.loadImageCallCount, 1)
    }

    // MARK: - Failure Cases

    func testShouldThrowErrorWhenRepositoryThrowsError() async {
        // Given
        mockRepository.loadImageResult = .failure(ImageError.networkError)

        // When & Then
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch let error as ImageError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
