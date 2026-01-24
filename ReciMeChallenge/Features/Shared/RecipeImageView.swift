//
//  RecipeImageView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

/// An image loader that handles URL fetching, loading states, and error fallbacks.
struct RecipeImageView: View {
    let recipe: Recipe
    var contentMode: ContentMode = .fill
    
    var body: some View {
        if let url = recipe.resolvedImageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                case .failure(_):
                    placeholderView
                case .empty:
                    loadingView
                @unknown default:
                    placeholderView
                }
            }
            .id(url) // Forces refresh if the URL changes
        } else {
            placeholderView
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        ZStack {
            Color.gray.opacity(0.05)
            HoppingDotsLoader()
        }
    }
    
    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: "fork.knife")
                .foregroundStyle(.secondary)
                .font(.system(size: 24, weight: .light))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let previewRecipe = Recipe(
        title: "Healthy Summer Salad",
        description: "A fresh and vibrant salad.",
        servings: 2,
        ingredients: [],
        instructions: [],
        dietaryAttributes: DietaryAttributes(),
        imageUrl: nil
    )
    
    RecipeImageView(recipe: previewRecipe)
}
