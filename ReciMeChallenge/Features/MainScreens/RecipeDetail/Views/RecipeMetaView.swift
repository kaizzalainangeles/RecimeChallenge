//
//  RecipeMetaView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

/// Displays the main headline of the recipe, including the title and serving information.
struct RecipeMetaView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.system(.largeTitle, design: .rounded).bold())
            
            HStack(spacing: 16) {
                Label("\(recipe.servings) servings", systemImage: "person.2.fill")
            }
            .font(.subheadline.bold())
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    let previewAttributes = DietaryAttributes(
        isVegetarian: true,
        isVegan: false,
        isGlutenFree: true,
        isSugarFree: true
    )
    
    let previewRecipe = Recipe(
        title: "Healthy Salad",
        description: "A fresh and vibrant salad.",
        servings: 2,
        ingredients: [],
        instructions: [],
        dietaryAttributes: previewAttributes,
        imageURL: nil
    )
    
    RecipeMetaView(recipe: previewRecipe)
}
