import Foundation

enum PuzzleError: LocalizedError, Equatable {
    case invalidImage
    case imageSplitFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Invalid image provided"
        case .imageSplitFailed:
            return "Failed to split image into tiles"
        }
    }
}
