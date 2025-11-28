import Foundation
import UIKit
import Combine

protocol PuzzleViewModel: Observable, ObservableObject, AnyObject {
    var sourceImage: UIImage? { get }
}

@Observable
final class PuzzleViewModelImpl: PuzzleViewModel {
    var sourceImage: UIImage?

    init(sourceImage: UIImage?) {
        self.sourceImage = sourceImage
    }
}

