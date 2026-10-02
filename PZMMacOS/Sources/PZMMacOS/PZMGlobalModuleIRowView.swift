import SwiftUI

/// Wrapper row component for module items
struct PZMGlobalModuleIRowView<Content: View>: View {
    let content: Content

    init(
        item: Any, // Or your specific domain model
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        HStack {
            content
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}