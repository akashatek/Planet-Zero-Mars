import SwiftUI

/// Square tile displaying a resource icon and rate.
struct PZMResourceTileView: View {
    let type: PZMResourceType
    let rateText: String
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: type.iconName)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(type.color)
            
            Text(rateText)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
        }
        .frame(width: 36, height: 36)
        .background(type.color.opacity(0.12))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(type.color.opacity(0.5), lineWidth: 1)
        )
    }
}

/// Top resource bar displaying global vaults.
struct PZMGlobalResourceView: View {
    @ObservedObject var engine: PZMSimulationEngine
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(PZMResourceType.allCases) { type in
                    if let vault = engine.globalVaults[type] {
                        PZMGlobalResourceItemView(vault: vault)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(NSColor.controlBackgroundColor))
    }
}

struct PZMGlobalResourceItemView: View {
    let vault: PZMGlobalVault
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PZMGlobalResourceItemLabelView(vault: vault)
            PZMGlobalResourceItemGraphView(vault: vault)
            
            Text("\(vault.available) / \(vault.capacity) \(vault.type.rawValue)")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(vault.type.color.opacity(0.12))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(vault.type.color.opacity(0.4), lineWidth: 1)
        )
    }
}

struct PZMGlobalResourceItemLabelView: View {
    let vault: PZMGlobalVault
    
    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: vault.type.iconName)
                    .foregroundColor(vault.type.color)
                    .font(.caption)
                Text(vault.type.rawValue)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if vault.type == .labour {
                Text("-\(vault.consumption)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.purple)
            } else {
                Text("\(vault.netRate >= 0 ? "+" : "")\(vault.netRate)/d")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(vault.netRate >= 0 ? .green : .red)
            }
        }
    }
}

struct PZMGlobalResourceItemGraphView: View {
    let vault: PZMGlobalVault
    let gridColumns = Array(repeating: GridItem(.fixed(10), spacing: 3), count: 10)
    
    var body: some View {
        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 3) {
            ForEach(0..<30, id: \.self) { index in
                let slotType = vault.gridSlots[index]
                RoundedRectangle(cornerRadius: 2)
                    .fill(slotType.color)
                    .frame(width: 10, height: 10)
            }
        }
    }
}