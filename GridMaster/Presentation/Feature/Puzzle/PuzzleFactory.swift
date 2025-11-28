import Foundation
import SwiftUI
import UIKit

struct PuzzleFactory {
    func impl(image: UIImage, gridSize: Int) -> some View {
        let splitImageUseCase = SplitImageIntoGridUseCase(gridSize: gridSize)
        let viewModel = PuzzleViewModelImpl(
            sourceImage: image,
            splitImageUseCase: splitImageUseCase,
            gridSize: gridSize
        )
        return PuzzleView(viewModel: viewModel)
    }
}
