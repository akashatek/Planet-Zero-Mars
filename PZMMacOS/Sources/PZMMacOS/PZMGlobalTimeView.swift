import SwiftUI

/// Bottom status bar showing time progression and colony stability estimates.
struct PZMGlobalTimeView: View {
    @ObservedObject var engine: PZMSimulationEngine
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 2) {
                Text("TIME ELAPSED")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                    Text("SOL \(engine.solDay)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                }
            }
            .frame(width: 140, alignment: .leading)
            
            Divider().frame(height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("ESTIMATED LIFESPAN")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                
                if let days = engine.minLifespanEstimate {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(days <= 3 ? .red : .orange)
                        Text("Depletion in \(days) Sol\(days == 1 ? "" : "s")")
                            .font(.callout)
                            .bold()
                            .foregroundColor(days <= 3 ? .red : .orange)
                    }
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.green)
                        Text("Stable (∞ Sols)")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.green)
                    }
                }
            }
            .frame(width: 200, alignment: .leading)
            
            Spacer()
            
            Divider().frame(height: 36)
            
            Button(action: {
                engine.advanceToNextSol()
            }) {
                HStack(spacing: 8) {
                    Text("NEXT SOL")
                        .font(.headline)
                        .bold()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title3)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
    }
}