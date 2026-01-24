//
//  FilterTagView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A small capsule view representing an active filter.
struct FilterTagView: View {
    let text: String
    let color: Color
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.footnote.weight(.medium))
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.12))
        .foregroundColor(color)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    FilterTagView(text: "Chicken", color: .red, onRemove: {})
}
