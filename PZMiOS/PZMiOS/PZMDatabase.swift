//
//  PZMDatabase.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 02/10/2026.
//


import Foundation
import SwiftData

@MainActor
final class PZMDatabase {
    static let shared = PZMDatabase()
    
    let container: ModelContainer
    
    var context: ModelContext {
        container.mainContext
    }
    
    init(inMemory: Bool = false) {
        do {
            let schema = Schema([
                PZMResourceItem.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
            container = try ModelContainer(for: schema, configurations: [config])
            
            seedInitialResources()
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    private func seedInitialResources() {
        let descriptor = FetchDescriptor<PZMResourceItem>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        
        guard count == 0 else { return }
        
        // Updated initial values: 7 for standard resources, 8 for Labor
        let defaults: [String: Int] = [
            PZMResource.oxygen.rawValue: 7, // Oxygen (O)
            PZMResource.heat.rawValue: 7,   // Heat (H)
            PZMResource.water.rawValue: 7,  // Water (W)
            PZMResource.food.rawValue: 7,   // Food (F)
            PZMResource.power.rawValue: 7,  // Power (P)
            PZMResource.labor.rawValue: 8   // Labor (L)
        ]
        
        for (code, amount) in defaults {
            let item = PZMResourceItem(rawCode: code, amount: amount)
            context.insert(item)
        }
        
        try? context.save()
    }
    
    /// Optional helper to reset resources back to default during testing/game restarts
    func resetToDefaults() {
        try? context.delete(model: PZMResourceItem.self)
        seedInitialResources()
    }
}
