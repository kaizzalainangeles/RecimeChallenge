//
//  RecipeImageView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

/// An image loader that handles both local file paths and remote URLs.
struct RecipeImageView: View {
    let recipe: Recipe
    var contentMode: ContentMode = .fill
    
    var body: some View {
        Group {
            if let url = recipe.resolvedImageURL {
                if url.isFileURL {
                    localImageView(for: url)
                } else {
                    remoteImageView(for: url)
                }
            } else {
                placeholderView
            }
        }
    }
    
    // MARK: - Image Variants
    
    /// Loads local files directly from disk to prevent URLSession cancellation errors.
    @ViewBuilder
    private func localImageView(for url: URL) -> some View {
        if let uiImage = UIImage(contentsOfFile: url.path) {
            styleImage(Image(uiImage: uiImage))
        } else {
            placeholderView
        }
    }
    
    /// Loads remote images using the standard AsyncImage pipeline.
    private func remoteImageView(for url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                styleImage(image)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            case .failure:
                placeholderView
            case .empty:
                loadingView
            @unknown default:
                placeholderView
            }
        }
        .id(url)
    }
    
    // MARK: - Helpers & Subviews

    private func styleImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
    
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
