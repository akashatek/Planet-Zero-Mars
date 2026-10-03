//
//  ColorExtension.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 02/10/2026.
//

import SwiftUI

// MARK: - Cross-Platform Color Extensions
extension Color {
    static var pzmBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemGroupedBackground)
        #else
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }
    
    static var pzmCardBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemGroupedBackground)
        #else
        return Color(nsColor: .controlBackgroundColor)
        #endif
    }
}

// MARK: - Cross-Platform Navigation Modifier
extension View {
    func pzmInlineNavigationTitle() -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(.inline)
        #else
        return self
        #endif
    }
}
