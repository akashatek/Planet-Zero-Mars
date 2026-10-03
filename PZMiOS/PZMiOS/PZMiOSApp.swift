//
//  PZMiOSApp.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 02/10/2026.
//

import SwiftUI
import SwiftData

@main
struct PZMiOSApp: App {
    // Database initializes container and seeds resources on access
    private let database = PZMDatabase.shared
    
    var body: some Scene {
        WindowGroup {
            PZMMainView()
                #if os(macOS)
                // Lock default and minimum window dimensions to 16:9 landscape aspect ratio
                .frame(minWidth: 960, minHeight: 540)
                .frame(idealWidth: 1152, idealHeight: 648)
                #endif
        }
        .modelContainer(database.container)
        #if os(macOS)
        // Disables tabbed window merging for standalone desktop game feel
        .windowResizability(.contentSize)
        #endif
    }
}
