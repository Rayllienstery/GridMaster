import XCTest
@testable import GridMaster

@MainActor
final class ImageRepositoryImplTests: XCTestCase {
    var repository: ImageRepositoryImpl!
    var mockSession: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        repository = nil
        mockSession = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func testShouldReturnImageDataWhenHTTP200ResponseReceived() async throws {
        // Given
        let expectedData = Data("test image data".utf8)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, expectedData)
        }
        repository = ImageRepositoryImpl(session: mockSession)

        // When
        let result = try await repository.loadImage()

        // Then
        XCTAssertEqual(result, expectedData)
    }

    // MARK: - Failure Cases

    func testShouldThrowNetworkErrorWhenHTTP404ResponseReceived() async {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        repository = ImageRepositoryImpl(session: mockSession)

        // When & Then
        do {
            _ = try await repository.loadImage()
            XCTFail("Expected networkError to be thrown")
        } catch let error as ImageError {
            XCTAssertEqual(error, .networkError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testShouldThrowInvalidDataWhenResponseDataIsEmpty() async {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        repository = ImageRepositoryImpl(session: mockSession)

        // When & Then
        do {
            _ = try await repository.loadImage()
            XCTFail("Expected invalidData to be thrown")
        } catch let error as ImageError {
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testShouldThrowLoadFailedWhenURLSessionThrowsError() async {
        // Given
        MockURLProtocol.requestHandler = { _ in
            throw NSError(domain: "TestError", code: -1)
        }
        repository = ImageRepositoryImpl(session: mockSession)

        // When & Then
        do {
            _ = try await repository.loadImage()
            XCTFail("Expected loadFailed to be thrown")
        } catch let error as ImageError {
            XCTAssertEqual(error, .loadFailed)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

}

// MARK: - Mock URL Protocol

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) async throws -> (HTTPURLResponse, Data))?

    override static func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "MockURLProtocol", code: -1))
            return
        }

        Task {
            do {
                let (response, data) = try await handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {
        // No-op
    }
}
