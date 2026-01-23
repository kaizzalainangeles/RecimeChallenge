//
//  DietaryTagsSectionView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct DietaryTagsSection: View {
    let recipe: Recipe
    
    var body: some View {
        if !recipe.dietaryAttributes.activeTags.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recipe.dietaryAttributes.activeTags) { tag in
                        DietaryTagView(tag: tag)
                    }
                }
            }
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
        title: "Healthy Summer Salad",
        description: "A fresh and vibrant salad.",
        servings: 2,
        ingredients: [],
        instructions: [],
        dietaryAttributes: previewAttributes,
        imageURL: nil
    )
    
    DietaryTagsSection(recipe: previewRecipe)
        .padding()
}
