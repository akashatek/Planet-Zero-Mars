//
//  PZMResource.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 02/10/2026.
//

import SwiftUI
import SwiftData

enum PZMResource: String, CaseIterable, Identifiable {
    case oxygen = "O"
    case heat = "H"
    case water = "W"
    case food = "F"
    case power = "P"
    case labor = "L"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .oxygen: return "Oxygen"
        case .heat:   return "Heat"
        case .water:  return "Water"
        case .food:   return "Food"
        case .power:  return "Power"
        case .labor:  return "Labor"
        }
    }
    
    var symbolName: String {
        switch self {
        case .oxygen: return "wind"
        case .heat:   return "thermometer.medium"
        case .water:  return "drop.fill"
        case .food:   return "fork.knife"
        case .power:  return "bolt.fill"
        case .labor:  return "figure.run"
        }
    }
    
    var color: Color {
        switch self {
        case .oxygen: return .cyan
        case .heat:   return .orange
        case .water:  return .blue
        case .food:   return .green
        case .power:  return .yellow
        case .labor:  return .purple
        }
    }
}

// MARK: - Resource Helper Collection
struct PZMResourceList {
    static let all: [PZMResource] = PZMResource.allCases
}

// MARK: - SwiftData Model Entity
@Model
final class PZMResourceItem {
    @Attribute(.unique) var rawCode: String
    var amount: Int
    var updatedAt: Date
    
    init(rawCode: String, amount: Int) {
        self.rawCode = rawCode
        self.amount = amount
        self.updatedAt = Date()
    }
    
    var resourceType: PZMResource? {
        PZMResource(rawValue: rawCode)
    }
}
