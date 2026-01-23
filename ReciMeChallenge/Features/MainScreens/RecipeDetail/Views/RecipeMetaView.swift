//
//  RecipeMetaView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct RecipeMetaView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.title)
                .font(.system(.largeTitle, design: .rounded).bold())
            
            HStack(spacing: 16) {
                Label("\(recipe.servings) servings", systemImage: "person.2.fill")
                
                if recipe.dietaryAttributes.isVegetarian == true {
                    Label("Vegetarian", systemImage: "leaf.fill")
                        .foregroundColor(.green)
                }
            }
            .font(.subheadline.bold())
            .foregroundColor(.secondary)
        }
    }
}
