import SwiftUI
import UIKit

/// A button component that displays a local asset image from the app bundle.
///
/// This component shows an image from Assets.xcassets if available, or a placeholder
/// if the asset cannot be loaded. When tapped, it executes the provided action.
///
/// - Parameters:
///   - assetName: The name of the asset in Assets.xcassets.
///   - action: The closure to execute when the button is tapped.
struct LocalAssetButton: View {
    let assetName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if let image = UIImage(named: assetName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(assetName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
