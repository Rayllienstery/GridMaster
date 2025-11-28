import Foundation
import SwiftUI
import UIKit

struct PuzzleFactory {
    func impl(image: UIImage) -> some View {
        let viewModel = PuzzleViewModelImpl(sourceImage: image)
        return PuzzleView(viewModel: viewModel)
    }
}
