import Foundation
import SwiftUI

struct HomeFactory {
    func impl() -> some View {
        let repository = ImageRepositoryImpl()
        let imageFetcher = PicsumImageFetcherUseCase(repository: repository)
        let networkMonitor = NetworkMonitor()
        let viewModel = HomeViewModelImpl(
            imageFetcher: imageFetcher,
            networkMonitor: networkMonitor
        )
        return HomeView(viewModel: viewModel)
    }
}
