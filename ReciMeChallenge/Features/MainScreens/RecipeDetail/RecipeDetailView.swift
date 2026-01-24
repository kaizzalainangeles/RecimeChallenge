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
            ZStack(alignment: .top) {
                // 1. Stretchy Full-width Image
                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    
                    RecipeImageView(recipe: recipe)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height + (minY > 0 ? minY : 0)
                        )
                        .clipped()
                        // This offset keeps the top of the image stuck to the top of the screen
                        .offset(y: minY > 0 ? -minY : 0)
                }
                .frame(height: 240)
                
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
                .cornerRadius(30)
                .padding(.top, 210) // overlaps with the image
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
