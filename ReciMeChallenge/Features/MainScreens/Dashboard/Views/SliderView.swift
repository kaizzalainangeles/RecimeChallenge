//
//  SliderView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct SliderView: View {
    // MARK: - Properties
    let title: String
    let recipes: [Recipe]
    let recipeGroupType: RecipeGroupType
    var onSeeMorePressed: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            
            ScrollView(.horizontal, showsIndicators: false) {
                if recipes.isEmpty {
                    emptyStateView
                } else {
                    recipeList
                }
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    // MARK: - Subviews
    private var headerSection: some View {
        Text(title)
            .font(.title2.bold())
            .padding(.horizontal)
    }
    
    private var recipeList: some View {
        HStack(spacing: 16) {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeCardView(recipe: recipe, style: .wide)
                        .frame(width: 300)
                }
                .buttonStyle(.plain)
            }
            
            seeMoreButton
        }
        .padding(.horizontal)
        .scrollTargetLayout()
    }
    
    private var seeMoreButton: some View {
        Button(action: onSeeMorePressed) {
            VStack(spacing: 12) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 30))
                Text("View More")
                    .font(.headline)
            }
            .frame(width: 150, height: 280)
            .foregroundColor(.orange)
            .background(.clear)
        }
        .foregroundStyle(.primary)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.orange.opacity(0.3))
            
            VStack(spacing: 4) {
                Text(getNoRecipeMessage())
                    .font(.headline)
                
                Text(getNoRecipeAddedMessage())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if recipeGroupType == .featured {
                exploreButton
            }
        }
        .frame(width: 300, height: 260)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                .foregroundColor(Color(.systemGray4))
        }
        .padding(.horizontal)
    }
    
    private var exploreButton: some View {
        Button(action: onSeeMorePressed) {
            Text("Explore Recipes")
                .font(.subheadline.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.orange.opacity(0.1)))
                .foregroundColor(.orange)
        }
        .background(.clear)
    }
    
    private func getNoRecipeMessage() -> String {
        if recipeGroupType == .featured {
            return "No featured recipes available."
        } else {
            return "You haven't added any recipes yet."
        }
    }
    
    private func getNoRecipeAddedMessage() -> String {
        if recipeGroupType == .featured {
            return "Try searching for something new to cook today!"
        } else {
            return "Try creating a recipe to see it here!"
        }
    }
}


#Preview {
    let previewRecipe = Recipe(
        title: "Fried Egg",
        description: "Crispy Fried Egg",
        servings: 2,
        ingredients: [Ingredient(name: "Egg", quantity: "1")],
        instructions: ["Cook", "Eat"],
        dietaryAttributes: DietaryAttributes(),
        imageURL: nil,
        creatorId: nil
    )
    
    SliderView(
        title: "Featured Foods",
        recipes: [previewRecipe],
        recipeGroupType: .featured,
        onSeeMorePressed: {}
    )
}
