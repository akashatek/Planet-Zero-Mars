//
//  PZMModuleView.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 03/10/2026.
//


import SwiftUI

// MARK: - Left Column: Active Modules List
struct PZMMainModuleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cpu")
                    .foregroundColor(.accentColor)
                Text("Active Modules")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ScrollView {
                VStack(spacing: 10) {
                    // Placeholder card
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.pzmCardBackground)
                        .frame(height: 70)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Solar Panel Array")
                                        .font(.subheadline)
                                        .bold()
                                    Text("Produces: +5 P/Sol")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("Active")
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal)
                        )
                }
                .padding(.horizontal)
            }
        }
        .background(Color.pzmBackground)
    }
}

// MARK: - Canvas Preview
#Preview {
    PZMMainModuleView()
}
