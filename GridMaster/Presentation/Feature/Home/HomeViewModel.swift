import Foundation
import Combine

protocol HomeViewModel: Observable, ObservableObject, AnyObject {
    var isNetworkAvailable: Bool { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

@Observable
final class HomeViewModelImpl: HomeViewModel {
    private let imageFetcher: PicsumImageFetcherUseCase
    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()

    var isNetworkAvailable: Bool = true
    var isLoading: Bool = false
    var errorMessage: String?

    init(imageFetcher: PicsumImageFetcherUseCase, networkMonitor: NetworkMonitorProtocol) {
        self.imageFetcher = imageFetcher
        self.networkMonitor = networkMonitor
        self.isNetworkAvailable = networkMonitor.currentStatus

        setupNetworkMonitoring()
    }

    private func setupNetworkMonitoring() {
        networkMonitor.isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isNetworkAvailable = isConnected
            }
            .store(in: &cancellables)
    }

    @MainActor
    func loadImage() async {
        guard isNetworkAvailable else {
            errorMessage = "Network is not available"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await imageFetcher.execute()
            // Image loaded successfully
        } catch let error as ImageError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Failed to load image"
        }

        isLoading = false
    }
}
