import Foundation

/// Image domain errors
enum ImageError: LocalizedError, Equatable {
    case networkError
    case invalidData
    case loadFailed

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Failed to load image from network"
        case .invalidData:
            return "Invalid image data"
        case .loadFailed:
            return "Failed to load image"
        }
    }
}

