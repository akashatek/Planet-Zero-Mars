import Foundation
import Combine

final class PZMSimulationEngine: ObservableObject {
    @Published var solDay: Int = 1
    @Published var globalVaults: [PZMResourceType: PZMGlobalVault] = [:]
    @Published var instances: [PZMModuleInstance] = []
    
    let blueprints: [PZMModuleBlueprint] = [
        PZMModuleBlueprint(
            id: "human_colonist",
            name: "Human Colonist",
            tiedResource: .labour,
            iconName: "person.fill",
            iconColor: .purple,
            isLander: false,
            isHuman: true,
            canBuildMultiple: true,
            buildLabourCost: 4,
            initialAvailable: [.labour: 8],
            capacityProvided: [.labour: 8],
            dailyConsumption: [.heat: 1, .food: 1, .water: 1, .oxygen: 1],
            dailyProduction: [:]
        ),
        PZMModuleBlueprint(
            id: "lander_core",
            name: "Lander Capsule",
            tiedResource: nil,
            iconName: "sparkles.rectangle.stack.fill",
            iconColor: .orange,
            isLander: true,
            isHuman: false,
            canBuildMultiple: false,
            buildLabourCost: 0,
            initialAvailable: [.energy: 10, .heat: 10, .food: 10, .water: 10, .oxygen: 10],
            capacityProvided: [.energy: 10, .heat: 10, .food: 10, .water: 10, .oxygen: 10],
            dailyConsumption: [.energy: 1],
            dailyProduction: [:]
        ),
        PZMModuleBlueprint(
            id: "solar_array",
            name: "Solar Array",
            tiedResource: .energy,
            iconName: "sun.max.fill",
            iconColor: .yellow,
            isLander: false,
            isHuman: false,
            canBuildMultiple: true,
            buildLabourCost: 2,
            initialAvailable: [:],
            capacityProvided: [.energy: 10],
            dailyConsumption: [:],
            dailyProduction: [.energy: 3]
        ),
        PZMModuleBlueprint(
            id: "water_evaporator",
            name: "Moisture Vaporator",
            tiedResource: .water,
            iconName: "drop.triangle.fill",
            iconColor: .blue,
            isLander: false,
            isHuman: false,
            canBuildMultiple: true,
            buildLabourCost: 3,
            initialAvailable: [:],
            capacityProvided: [.water: 10],
            dailyConsumption: [.energy: 1],
            dailyProduction: [.water: 2]
        ),
        PZMModuleBlueprint(
            id: "greenhouse",
            name: "Hydroponic Greenhouse",
            tiedResource: .food,
            iconName: "leaf.circle.fill",
            iconColor: .green,
            isLander: false,
            isHuman: false,
            canBuildMultiple: true,
            buildLabourCost: 4,
            initialAvailable: [:],
            capacityProvided: [.food: 10, .oxygen: 10],
            dailyConsumption: [.water: 1, .energy: 1],
            dailyProduction: [.food: 2, .oxygen: 1]
        )
    ]
    
    init() {
        setupInitialState()
    }
    
    private func setupInitialState() {
        instances = [
            PZMModuleInstance(blueprintId: "human_colonist"),
            PZMModuleInstance(blueprintId: "lander_core")
        ]
        
        for type in PZMResourceType.allCases {
            let cap = type == .labour ? 8 : 10
            globalVaults[type] = PZMGlobalVault(
                type: type,
                available: cap,
                consumption: 0,
                production: 0,
                capacity: cap
            )
        }
        
        recalculateGlobalVaults()
    }
    
    var humanCount: Int {
        instances.filter { $0.blueprintId == "human_colonist" }.count
    }
    
    var totalLabourCapacity: Int {
        humanCount * 8
    }
    
    var availableLabour: Int {
        globalVaults[.labour]?.available ?? 0
    }
    
    var minLifespanEstimate: Int? {
        var minDays: Double = .infinity
        for type in PZMResourceType.allCases where type != .labour {
            if let vault = globalVaults[type] {
                if vault.netRate < 0 {
                    let daysLeft = Double(vault.available) / Double(abs(vault.netRate))
                    if daysLeft < minDays {
                        minDays = daysLeft
                    }
                }
            }
        }
        return minDays == .infinity ? nil : Int(minDays)
    }
    
    func canBuild(_ blueprint: PZMModuleBlueprint) -> Bool {
        guard blueprint.canBuildMultiple else { return false }
        return availableLabour >= blueprint.buildLabourCost
    }
    
    func buildModule(blueprint: PZMModuleBlueprint) {
        guard canBuild(blueprint) else { return }
        
        if var labourVault = globalVaults[.labour] {
            labourVault.available -= blueprint.buildLabourCost
            labourVault.consumption += blueprint.buildLabourCost
            globalVaults[.labour] = labourVault
        }
        
        instances.append(PZMModuleInstance(blueprintId: blueprint.id))
        
        for (res, cap) in blueprint.capacityProvided {
            if var vault = globalVaults[res] {
                vault.capacity += cap
                vault.available += blueprint.initialAvailable[res] ?? 0
                globalVaults[res] = vault
            }
        }
        
        recalculateGlobalVaults()
    }
    
    func removeInstance(id: UUID) {
        if let idx = instances.firstIndex(where: { $0.id == id }) {
            let instance = instances[idx]
            if let bp = blueprints.first(where: { $0.id == instance.blueprintId }), !bp.isLander {
                instances.remove(at: idx)
                
                for (res, cap) in bp.capacityProvided {
                    if var vault = globalVaults[res] {
                        vault.capacity = max(0, vault.capacity - cap)
                        vault.available = min(vault.available, vault.capacity)
                        globalVaults[res] = vault
                    }
                }
            }
        }
        recalculateGlobalVaults()
    }
    
    func recalculateGlobalVaults() {
        var dailyCons: [PZMResourceType: Int] = [:]
        var dailyProd: [PZMResourceType: Int] = [:]
        
        PZMResourceType.allCases.forEach {
            dailyCons[$0] = 0
            dailyProd[$0] = 0
        }
        
        for instance in instances {
            if let bp = blueprints.first(where: { $0.id == instance.blueprintId }) {
                for (res, val) in bp.dailyConsumption {
                    dailyCons[res, default: 0] += val
                }
                for (res, val) in bp.dailyProduction {
                    dailyProd[res, default: 0] += val
                }
            }
        }
        
        if var labourVault = globalVaults[.labour] {
            labourVault.capacity = totalLabourCapacity
            globalVaults[.labour] = labourVault
        }
        
        for type in PZMResourceType.allCases where type != .labour {
            if var vault = globalVaults[type] {
                vault.consumption = dailyCons[type] ?? 0
                vault.production = dailyProd[type] ?? 0
                globalVaults[type] = vault
            }
        }
    }
    
    func advanceToNextSol() {
        solDay += 1
        
        for type in PZMResourceType.allCases {
            guard var vault = globalVaults[type] else { continue }
            if type == .labour {
                vault.available = vault.capacity
                vault.consumption = 0
            } else {
                vault.available = max(0, min(vault.capacity, vault.available + vault.netRate))
            }
            globalVaults[type] = vault
        }
        
        recalculateGlobalVaults()
    }
    
    func activeInstances(for blueprintId: String) -> [PZMModuleInstance] {
        instances.filter { $0.blueprintId == blueprintId }
    }
}