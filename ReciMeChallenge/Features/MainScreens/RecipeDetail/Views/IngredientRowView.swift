//
//  IngredientRowView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct IngredientRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .font(.body)
            Spacer()
            Text(ingredient.quantity)
                .font(.subheadline.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    IngredientRowView(ingredient: Ingredient(name: "Beef", quantity: "1kg"))
        .padding()
}
