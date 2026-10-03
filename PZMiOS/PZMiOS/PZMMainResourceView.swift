import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct PZMResourceTile: View {
    let resource: PZMResource
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            // Icon
            Image(systemName: resource.symbolName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            // Value Count
            Text("\(value)")
                .font(.system(.subheadline, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1.0, contentMode: .fit) // Square proportion
        .background(resource.color)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: resource.color.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}

struct PZMMainResourceView: View {
    @Query(sort: \PZMResourceItem.rawCode) private var globalItems: [PZMResourceItem]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(PZMResource.allCases) { resource in
                let item = globalItems.first { $0.rawCode == resource.rawValue }
                let amount = item?.amount ?? 0
                
                PZMResourceTile(resource: resource, value: amount)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.pzmCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal)
    }
}

// MARK: - Canvas Preview
#Preview {
    PZMMainResourceView()
        .modelContainer(PZMDatabase(inMemory: true).container)
}


