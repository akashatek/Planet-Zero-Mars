import Foundation
import SwiftUI

enum ResourceSquareType {
    case available   // Green
    case consumed    // Red
    case produced    // Orange
    case empty       // Gray
    
    var color: Color {
        switch self {
        case .available: return .green
        case .consumed: return .red
        case .produced: return .orange
        case .empty: return Color.gray.opacity(0.25)
        }
    }
}

struct PZMGlobalVault {
    let type: PZMResourceType
    var available: Int
    var consumption: Int
    var production: Int
    var capacity: Int
    
    var netRate: Int {
        production - consumption
    }
    
    var gridSlots: [ResourceSquareType] {
        var slots: [ResourceSquareType] = []
        
        let netConsumption = max(0, consumption - production)
        let netProduction = max(0, production - consumption)
        let totalEffective = min(capacity, available + netProduction)
        
        for i in 0..<30 {
            if i < capacity {
                if i < max(0, available - netConsumption) {
                    slots.append(.available)
                } else if i < available {
                    slots.append(.consumed)
                } else if i < totalEffective {
                    slots.append(.produced)
                } else {
                    slots.append(.empty)
                }
            } else {
                slots.append(.empty)
            }
        }
        return slots
    }
}

struct PZMModuleBlueprint: Identifiable {
    let id: String
    let name: String
    let tiedResource: PZMResourceType?
    let iconName: String
    let iconColor: Color
    let isLander: Bool
    let isHuman: Bool
    let canBuildMultiple: Bool
    let buildLabourCost: Int
    
    let initialAvailable: [PZMResourceType: Int]
    let capacityProvided: [PZMResourceType: Int]
    let dailyConsumption: [PZMResourceType: Int]
    let dailyProduction: [PZMResourceType: Int]
}

struct PZMModuleInstance: Identifiable {
    let id: UUID
    let blueprintId: String
    
    init(id: UUID = UUID(), blueprintId: String) {
        self.id = id
        self.blueprintId = blueprintId
    }
}