//
//  FeaturedSliderView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct SliderView: View {
    let title: String
    let recipes: [Recipe]
    let noRecipesMessage: String
    var onSeeMorePressed: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                if !recipes.isEmpty {
                    HStack(spacing: 16) {
                        ForEach(recipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeCard(recipe: recipe)
                                    .frame(width: 300)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // The "More" Button at the end
                        Button(action: onSeeMorePressed) {
                            VStack(spacing: 12) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 30))
                                Text("View More")
                                    .font(.headline)
                            }
                            .frame(width: 150, height: 280)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .scrollTargetLayout() // Optimization for snapping
                } else {
                    VStack(alignment: .center, spacing: 16) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.orange.opacity(0.3))
                        
                        VStack(spacing: 4) {
                            Text(noRecipesMessage)
                                .font(.headline)
                            
                            Text("Try searching for something new to cook today!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: { onSeeMorePressed() }) {
                            Text("Explore Recipes")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(Color.orange.opacity(0.1)))
                                .foregroundColor(.orange)
                        }
                    }
                    .frame(width: 320, height: 280)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                            .foregroundColor(Color(.systemGray4))
                    )
                    .padding(.horizontal)
                }
            }
            .scrollTargetBehavior(.viewAligned) // Snaps to cards
        }
    }
}
