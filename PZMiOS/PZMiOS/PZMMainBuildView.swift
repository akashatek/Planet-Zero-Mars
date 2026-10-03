//
//  PZMBuildView.swift
//  PZMiOS
//
//  Created by Alvin HEIB on 03/10/2026.
//

import SwiftUI

// MARK: - Right Column: Build Options List
struct PZMMainBuildView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "hammer.fill")
                    .foregroundColor(.orange)
                Text("Build Menu")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ScrollView {
                VStack(spacing: 10) {
                    // Placeholder build card
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.pzmCardBackground)
                        .frame(height: 75)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Hydroponics Farm")
                                        .font(.subheadline)
                                        .bold()
                                    Text("Cost: 20 P • 10 W • 2 L")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button("Build") {
                                    // Action to build module
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
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
    PZMMainBuildView()
}
