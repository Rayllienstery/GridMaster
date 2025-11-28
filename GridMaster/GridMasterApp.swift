import SwiftUI

@main
struct GridMasterApp: App {
    var body: some Scene {
        WindowGroup {
            HomeFactory().impl()
        }
    }
}
