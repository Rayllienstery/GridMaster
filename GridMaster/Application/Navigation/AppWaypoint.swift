import Foundation
import SwiftUI
import TMNavigation
import UIKit

enum AppWaypoint: TMWaypoint {
    case puzzle(image: UIImage, gridSize: Int)

    func view(coordinator: any TMCoordinatorProtocol) -> AnyView {
        switch self {
        case .puzzle(let image, let gridSize):
            let factory = PuzzleFactory()
            return AnyView(factory.impl(image: image, gridSize: gridSize))
        }
    }
}

