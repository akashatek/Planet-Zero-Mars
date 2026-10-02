import SwiftUI

struct PZMModuleRowView: View {
    let blueprint: PZMModuleBlueprint
    @ObservedObject var engine: PZMSimulationEngine
    
    var activeInstances: [PZMModuleInstance] {
        engine.activeInstances(for: blueprint.id)
    }
    
    var isBuildable: Bool {
        engine.canBuild(blueprint)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: 1. Leftmost: Active Count Counter
            VStack(spacing: 2) {
                Text("\(activeInstances.count)")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(activeInstances.isEmpty ? .secondary : blueprint.iconColor)
                Text("ACTIVE")
                    .font(.system(size: 7, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 44, height: 56)
            .background(blueprint.iconColor.opacity(activeInstances.isEmpty ? 0.05 : 0.15))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(blueprint.iconColor.opacity(activeInstances.isEmpty ? 0.2 : 0.6), lineWidth: 1)
            )
            
            // MARK: 2. Build Button & Blueprint Title
            HStack(spacing: 10) {
                Button(action: {
                    engine.buildModule(blueprint: blueprint)
                }) {
                    VStack(spacing: 3) {
                        Image(systemName: blueprint.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(isBuildable ? blueprint.iconColor : .gray)
                        Text(blueprint.isLander ? "CORE" : "BUILD")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(isBuildable ? .primary : .secondary)
                    }
                    .frame(width: 58, height: 56)
                    .background(isBuildable ? blueprint.iconColor.opacity(0.15) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isBuildable ? blueprint.iconColor : Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
                .disabled(!isBuildable)
                .opacity(isBuildable ? 1.0 : 0.4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(blueprint.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if let res = blueprint.tiedResource {
                        Text("TIED TO \(res.rawValue.uppercased())")
                            .font(.system(size: 8, weight: .bold))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(res.color.opacity(0.2))
                            .foregroundColor(res.color)
                            .cornerRadius(4)
                    }
                }
            }
            .frame(width: 170, alignment: .leading)
            
            Divider()
            
            // MARK: 3. Swimlane COST (Canonical Resource Ordering)
            VStack(alignment: .leading, spacing: 4) {
                Text("COST")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                if blueprint.buildLabourCost == 0 {
                    Text("Free")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(height: 36)
                } else {
                    HStack(spacing: 5) {
                        ForEach(PZMResourceType.allCases) { type in
                            if type == .labour {
                                PZMResourceTileView(type: .labour, rateText: "-\(blueprint.buildLabourCost)")
                            }
                        }
                    }
                }
            }
            .frame(width: 45, alignment: .leading)
            
            Divider()
            
            // MARK: 4. Swimlane CONSUMES (5-item Capacity, Canonical Resource Ordering)
            VStack(alignment: .leading, spacing: 4) {
                Text("CONSUMES")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                if blueprint.dailyConsumption.isEmpty {
                    Text("None")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(height: 36)
                } else {
                    HStack(spacing: 5) {
                        ForEach(PZMResourceType.allCases) { type in
                            if let amount = blueprint.dailyConsumption[type] {
                                PZMResourceTileView(type: type, rateText: "-\(amount)")
                            }
                        }
                    }
                }
            }
            .frame(width: 205, alignment: .leading)
            
            Divider()
            
            // MARK: 5. Swimlane PRODUCES (5-item Capacity, Canonical Resource Ordering)
            VStack(alignment: .leading, spacing: 4) {
                Text("PRODUCES")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                if blueprint.dailyProduction.isEmpty {
                    Text("None")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(height: 36)
                } else {
                    HStack(spacing: 5) {
                        ForEach(PZMResourceType.allCases) { type in
                            if let amount = blueprint.dailyProduction[type] {
                                PZMResourceTileView(type: type, rateText: "+\(amount)")
                            }
                        }
                    }
                }
            }
            .frame(width: 205, alignment: .leading)
            
            Divider()
            
            // MARK: 6. Swimlane CAPACITY (5-item Capacity, Canonical Resource Ordering)
            VStack(alignment: .leading, spacing: 4) {
                Text("CAPACITY")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                if blueprint.capacityProvided.isEmpty {
                    Text("None")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(height: 36)
                } else {
                    HStack(spacing: 5) {
                        ForEach(PZMResourceType.allCases) { type in
                            if let amount = blueprint.capacityProvided[type] {
                                PZMResourceTileView(type: type, rateText: "+\(amount)")
                            }
                        }
                    }
                }
            }
            .frame(width: 205, alignment: .leading)
            
            Divider()
            
            // MARK: 7. Interactive Instance Deconstruction Buttons
            VStack(alignment: .trailing, spacing: 4) {
                Text("DISMANTLE")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        if activeInstances.isEmpty {
                            Text("None")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(activeInstances) { instance in
                                Button(action: {
                                    if !blueprint.isLander {
                                        engine.removeInstance(id: instance.id)
                                    }
                                }) {
                                    Image(systemName: blueprint.iconName)
                                        .font(.system(size: 12))
                                        .foregroundColor(blueprint.iconColor)
                                        .padding(5)
                                        .background(blueprint.iconColor.opacity(0.15))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                .disabled(blueprint.isLander)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(10)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(10)
    }
}