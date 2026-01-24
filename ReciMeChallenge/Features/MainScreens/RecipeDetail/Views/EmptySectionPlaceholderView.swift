//
//  EmptySectionPlaceholderView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A subtle, italicized view used to indicate when a recipe section (like Description) is empty.
struct EmptySectionPlaceholderView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.footnote)
            
            Text(message)
                .font(.subheadline)
        }
        .italic()
        .foregroundColor(.secondary.opacity(0.7))
        .padding(.vertical, 8)
    }
}

#Preview {
    EmptySectionPlaceholderView(message: "Hello, world!")
}
