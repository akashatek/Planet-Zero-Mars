import SwiftUI

/// Canonical resources in the Mars simulation engine.
enum PZMResourceType: String, CaseIterable, Identifiable {
    case labour = "Labour"
    case energy = "Energy"
    case oxygen = "Oxygen"
    case heat = "Heat"
    case water = "Water"
    case food = "Food"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .labour: return "hammer.fill"
        case .energy: return "bolt.fill"
        case .oxygen: return "wind"
        case .heat: return "thermometer.medium"
        case .water: return "drop.fill"
        case .food: return "leaf.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .labour: return .purple
        case .energy: return .yellow
        case .oxygen: return .cyan
        case .heat: return .orange
        case .water: return .blue
        case .food: return .green
        }
    }
}