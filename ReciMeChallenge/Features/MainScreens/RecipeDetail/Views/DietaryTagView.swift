//
//  DietaryTagView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A tag representing a single dietary attribute with an icon and label.
struct DietaryTagView: View {
    let tag: DietaryAttributes.DietTag
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: tag.icon)
                .font(.caption2.bold())
            Text(tag.label)
                .font(.caption.bold())
                .textCase(.uppercase)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tag.color.opacity(0.12))
        .foregroundColor(tag.color)
        .clipShape(Capsule())
    }
}

#Preview {
    DietaryTagView(tag: .init(label: "Vegetarian", icon: "leaf.fill", color: .green))
}
