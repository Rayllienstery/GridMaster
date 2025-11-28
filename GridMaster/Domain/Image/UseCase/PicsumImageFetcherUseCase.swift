import Foundation

final class PicsumImageFetcherUseCase {
    private let repository: ImageRepositoryProtocol

    init(repository: ImageRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> Data {
        try await repository.loadImage()
    }
}
