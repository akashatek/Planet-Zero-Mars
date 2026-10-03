//
//  PMZMainGameView.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 02/10/2026.
//

import SwiftUI
import SwiftData

struct PZMMainView: View {
    @State private var currentYear: Int = 2030
    @State private var currentMonth: Int = 1
    @State private var currentSol: Int = 1
    @State private var estimatedSurvivalSols: Int = 7
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Bar: 6-Resource Status Bar
                PZMMainResourceView()
                    .padding(.vertical, 8)
                    .background(Color.pzmCardBackground)
                
                Divider()
                
                // Middle Section: 2-Column Split Workspace
                HStack(spacing: 0) {
                    // Left Column: Active Modules List
                    PZMMainModuleView()
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // Right Column: Available Modules to Build
                    PZMMainBuildView()
                        .frame(maxWidth: .infinity)
                }
                
                Divider()
                
                // Bottom Bar: Date, Survival Estimate & Action Button
                PZMMainTimeView(
                    year: currentYear,
                    month: currentMonth,
                    sol: currentSol,
                    estimatedSurvivalSols: estimatedSurvivalSols,
                    onNextSol: advanceSol
                )
            }
            .navigationTitle("PZM Terminal")
            .pzmInlineNavigationTitle()
        }
    }
    
    // MARK: - Game Loop Action
    private func advanceSol() {
        currentSol += 1
        if currentSol > 30 {
            currentSol = 1
            currentMonth += 1
            if currentMonth > 12 {
                currentMonth = 1
                currentYear += 1
            }
        }
        
        // TODO: Call game loop ticker engine here to consume/produce resources per module
    }
}

#Preview {
    PZMMainView()
        .modelContainer(PZMDatabase(inMemory: true).container)
}
