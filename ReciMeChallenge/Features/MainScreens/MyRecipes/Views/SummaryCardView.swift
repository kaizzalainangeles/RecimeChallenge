//
//  SummaryCardView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/24/26.
//

import SwiftUI

struct SummaryCardView: View {
    let recipeCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(recipeCount)")
                    .font(.title.bold())
                Text("Total Recipes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange.opacity(0.8))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    SummaryCardView(recipeCount: 10)
}
