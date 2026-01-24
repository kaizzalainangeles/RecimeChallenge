//
//  UpperGradientView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A Gradient View used to give accent to the 3 main screens (Dashboard, Search, My Recipe)
struct UpperGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.orange.opacity(0.7), Color(.systemGroupedBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 300)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    UpperGradientView()
}
