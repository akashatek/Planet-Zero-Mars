//
//  PZMTimeView.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 03/10/2026.
//


import SwiftUI

struct PZMMainTimeView: View {
    var year: Int = 2030
    var month: Int = 1
    var sol: Int = 1
    var estimatedSurvivalSols: Int = 7
    var onNextSol: () ->    Void
    
    var body: some View {
        HStack {
            // Calendar Readout
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(.accentColor)
                Text("Year \(year) Month \(month) Sol \(sol)")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Survival Estimate Readout
            HStack(spacing: 6) {
                Image(systemName: "hourglass.circle.fill")
                    .foregroundColor(estimatedSurvivalSols < 3 ? .red : .orange)
                Text("Est. Survival: \(estimatedSurvivalSols) Sols")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Action Button
            Button(action: onNextSol) {
                HStack(spacing: 6) {
                    Text("Next Sol")
                        .fontWeight(.bold)
                    Image(systemName: "forward.fill")
                        .font(.caption)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.pzmCardBackground)
    }
}

// MARK: - Canvas Preview
#Preview {
    PZMMainTimeView(
        year: 2030,
        month: 1,
        sol: 1,
        estimatedSurvivalSols: 7,
        onNextSol: {
            print("Advance Sol")
        }
    )
}
