//
//  RecipeCardView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// Defines how the recipe card should look
enum CardStyle: Equatable {
    case minimal(context: MinimalContext)    // For Grids (Explore and MyRecipes)
    case wide       // For Horizontal scrolling (Dashboard)
    
    enum MinimalContext {
        case explore    // Show description
        case myRecipes  // Show ingredient count
    }
}

/// A card view that display some recipe main detail based on a provided style.
struct RecipeCardView: View {
    let recipe: Recipe
    let style: CardStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. IMAGE SECTION
            RecipeImageView(recipe: recipe)
                .frame(height: imageSize)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .clipped()
            
            // 2. INFO SECTION
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    Text(recipe.title)
                        .font(titleFont)
                        .lineLimit(1)
                    
                    if style == .wide && recipe.dietaryAttributes.isVegetarian == true {
                        Spacer()
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Text(secondaryText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(style == .wide ? 16 : 8)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(cornerRadius)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Dynamic Properties based on Style
    
    private var imageSize: CGFloat {
        switch style {
        case .minimal:
            return 120
        case .wide:
            return 200
        }
    }
    
    private var titleFont: Font {
        switch style {
        case .wide:
            return .title3.bold()
        default:
            return .subheadline.bold()
        }
    }
    
    private var secondaryText: String {
        switch style {
        case .wide:
            return recipe.description
        case .minimal(let context):
            switch context {
            case .explore:
                return recipe.description
            case .myRecipes:
                return "\(recipe.ingredients.count) Ingredients"
            }
        }
    }
    
    private var cornerRadius: CGFloat {
        style == .wide ? 20 : 15
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
    
    RecipeCardView(recipe: previewRecipe, style: .wide)
        .padding()
}
