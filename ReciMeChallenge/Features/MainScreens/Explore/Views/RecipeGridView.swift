//
//  RecipeGridView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A vertically scrolling grid that displays recipe cards in a responsive layout.
struct RecipeGridView: View {
    let recipes: [Recipe]
    var isLoadingMore: Bool = false
    var onReachEnd: (() -> Void)? = nil // Pagination trigger
    
    /// Defines a responsive grid: it fits as many columns as possible with a minimum width of 170pt.
    private let columns = [
        GridItem(.adaptive(minimum: 170, maximum: .infinity), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(recipes) { recipe in
                    NavigationLink(value: recipe) {
                        RecipeCardView(recipe: recipe, style: .minimal(context: .explore))
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        // If this is the last recipe, trigger pagination
                        if recipe == recipes.last {
                            onReachEnd?()
                        }
                    }
                }
                
                if isLoadingMore {
                    Section(footer: HoppingDotsLoader().frame(maxWidth: .infinity).padding()) {
                        EmptyView()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let previewRecipes = [
        Recipe(
            title: "Fried Egg",
            description: "Crispy Fried Egg",
            servings: 2,
            ingredients: [Ingredient(name: "Egg", quantity: "1")],
            instructions: ["Cook", "Eat"],
            dietaryAttributes: DietaryAttributes(),
            imageURL: nil,
            creatorId: nil
        ),
        Recipe(
            title: "Fried Chicken",
            description: "Crispy Fried Chicken",
            servings: 2,
            ingredients: [Ingredient(name: "Chicken", quantity: "1")],
            instructions: ["Cook", "Eat"],
            dietaryAttributes: DietaryAttributes(),
            imageURL: nil,
            creatorId: nil
        )
    ]
    
    RecipeGridView(recipes: previewRecipes, isLoadingMore: true, onReachEnd: {})
}
