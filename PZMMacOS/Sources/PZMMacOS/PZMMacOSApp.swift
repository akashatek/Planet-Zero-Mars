
import SwiftUI
import AppKit

@main
struct PZMMacOSApp: App {
    var body: some Scene {
        WindowGroup("Mars PZM Engine") {
            PZMMainDashboardView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}