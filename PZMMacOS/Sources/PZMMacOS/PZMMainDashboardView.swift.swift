import SwiftUI

struct PZMMainDashboardView<Item: Identifiable, RowContent: View>: View {
    let moduleItems: [Item]
    @ViewBuilder let rowContent: (Item) -> RowContent
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Top status section featuring renamed core views
                HStack(spacing: 12) {
                    PZMMainResourceView()
                    PZMMainTimeView()
                }
                .padding(.horizontal)
                
                // Main module listing section
                PZMGlobalModuleView(items: moduleItems, rowContent: rowContent)
            }
            .navigationTitle("Dashboard")
        }
    }
}