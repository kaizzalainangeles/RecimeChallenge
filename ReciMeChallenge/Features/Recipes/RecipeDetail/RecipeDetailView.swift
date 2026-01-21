//
//  RecipeDetailView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 1. Full-width Image
                RecipeImageView(imageURL: recipe.imageURL)
                
                VStack(alignment: .leading, spacing: 24) {
                    // 2. Title
                    RecipeMetaView(recipe: recipe)
                    
                    // 3. Description
                    RecipeSectionView(title: "About the Dish") {
                        Text(recipe.description)
                            .font(.body)
                            .lineSpacing(4)
                            .foregroundColor(.secondary)
                    }
                    
                    // 4. Ingredients
                    RecipeSectionView(title: "Ingredients") {
                        VStack(spacing: 12) {
                            ForEach(recipe.ingredients) { ingredient in
                                IngredientRow(ingredient: ingredient)
                            }
                        }
                    }
                    
                    // 5. Instructions
                    RecipeSectionView(title: "Steps") {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(recipe.instructions.indices, id: \.self) { index in
                                InstructionStepRow(index: index, text: recipe.instructions[index])
                            }
                        }
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(30) // Overlaps the image slightly
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
    }
}
