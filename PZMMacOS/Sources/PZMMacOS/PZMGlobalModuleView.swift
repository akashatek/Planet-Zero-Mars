import SwiftUI

struct PZMGlobalModuleView<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let rowContent: (Item) -> Content

    init(
        items: [Item],
        @ViewBuilder rowContent: @escaping (Item) -> Content
    ) {
        self.items = items
        self.rowContent = rowContent
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(items) { item in
                    PZMGlobalModuleIRowView(item: item) {
                        rowContent(item)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

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