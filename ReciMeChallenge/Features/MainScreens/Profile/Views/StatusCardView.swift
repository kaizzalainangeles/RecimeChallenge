//
//  StatusCardView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

/// A small, square-ish card used to display a single metric (e.g., Follower count).
struct StatusCardView: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(color)
            
            Text(value.description)
                .font(.headline)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StatusCardView(
        title: "Recipes",
        value: 1,
        icon: "fork.knife",
        color: .orange
    )
}
