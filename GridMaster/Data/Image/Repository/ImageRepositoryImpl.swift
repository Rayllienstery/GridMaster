import Foundation

/// Implementation of ImageRepositoryProtocol
final class ImageRepositoryImpl: ImageRepositoryProtocol {
    private let url: URL
    private let session: URLSession

    init(url: URL = URL(string: "https://picsum.photos/1024")!, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    func loadImage() async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ImageError.networkError
            }

            guard !data.isEmpty else {
                throw ImageError.invalidData
            }

            return data
        } catch let error as ImageError {
            throw error
        } catch {
            throw ImageError.loadFailed
        }
    }
}
