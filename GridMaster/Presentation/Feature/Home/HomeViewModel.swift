import Foundation
import Combine
import UIKit
import TMNavigation

protocol HomeViewModel: Observable, ObservableObject, AnyObject {
  var isNetworkAvailable: Bool { get }
  var isLoading: Bool { get }
  var errorMessage: String? { get }
  var selectedGridSize: Int { get set }

  @MainActor func loadImage(coordinator: TMCoordinator<AppWaypoint>) async
  @MainActor func selectLocalAsset(_ assetName: String, coordinator: TMCoordinator<AppWaypoint>)
}

@Observable
final class HomeViewModelImpl: HomeViewModel {
    private let imageFetcher: PicsumImageFetcherUseCase
    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()

    var isNetworkAvailable: Bool = true
    var isLoading: Bool = false
    var errorMessage: String?
    var selectedGridSize: Int = 3

    init(
        imageFetcher: PicsumImageFetcherUseCase,
        networkMonitor: NetworkMonitorProtocol
    ) {
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
    func loadImage(coordinator: TMCoordinator<AppWaypoint>) async {
        guard isNetworkAvailable else {
            errorMessage = "Network is not available"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let imageData = try await imageFetcher.execute()
            if let image = UIImage(data: imageData) {
                coordinator.append(.puzzle(image: image, gridSize: selectedGridSize))
            } else {
                errorMessage = ImageError.invalidData.errorDescription
            }
        } catch let error as ImageError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Failed to load image"
        }

        isLoading = false
    }

    @MainActor
    func selectLocalAsset(_ assetName: String, coordinator: TMCoordinator<AppWaypoint>) {
        guard let image = UIImage(named: assetName) else {
            errorMessage = "Failed to load local asset: \(assetName)"
            return
        }
        coordinator.append(.puzzle(image: image, gridSize: selectedGridSize))
    }
}
