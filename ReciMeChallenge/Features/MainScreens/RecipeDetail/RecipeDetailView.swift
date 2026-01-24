//
//  RecipeDetailView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

/// The screen responsible for displaying all details for a specific recipe.
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 1. Full-width Image
                RecipeImageView(recipe: recipe)
                    .frame(height: 240)
                    .overlay(
                        LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .top, endPoint: .center)
                    )
                    .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // 2. Title
                    RecipeMetaView(recipe: recipe)
                    
                    // 3. Dietary Attributes
                    DietaryTagsSection(recipe: recipe)
                    
                    // 4. Description
                    RecipeSectionView(title: "About the Dish") {
                        if !recipe.description.isEmpty {
                            Text(recipe.description)
                                .font(.body)
                                .lineSpacing(4)
                                .foregroundColor(.secondary)
                        } else {
                            EmptySectionPlaceholderView(message: "No description provided.")
                        }
                    }
                    
                    // 5. Ingredients
                    RecipeSectionView(title: "Ingredients") {
                        if !recipe.ingredients.isEmpty {
                            VStack(spacing: 12) {
                                ForEach(recipe.ingredients) { ingredient in
                                    IngredientRowView(ingredient: ingredient)
                                }
                            }
                        } else {
                            EmptySectionPlaceholderView(message: "No ingredients listed.")
                        }
                    }
                    
                    // 6. Instructions
                    RecipeSectionView(title: "Steps") {
                        if !recipe.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(recipe.instructions.indices, id: \.self) { index in
                                    InstructionStepRowView(index: index, text: recipe.instructions[index])
                                }
                            }
                        } else {
                            EmptySectionPlaceholderView(message: "No instructions available.")
                        }
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(30)
                .offset(y: -30) // Overlaps the image slightly
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let previewRecipe = Recipe(
        title: "Healthy Salad",
        description: "A fresh and vibrant salad.",
        servings: 2,
        ingredients: [],
        instructions: [],
        dietaryAttributes: DietaryAttributes(),
        imageUrl: nil
    )
    
    RecipeDetailView(recipe: previewRecipe)
}
