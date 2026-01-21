//
//  RecipeCard.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = recipe.imageURL {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    } else {
                        ZStack {
                            Color.gray.opacity(0.05)
                            HoppingDotsLoader()
                        }
                    }
                }
            } else {
                Image(systemName: "fork.knife")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.title)
                        .font(.title3.bold())
                    
                    Spacer()
                    
                    if recipe.dietaryAttributes.isVegetarian == true {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct ModernHoppingLoader: View {
    @State private var animPhase: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                VStack(spacing: 4) {
                    Circle()
                        .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
                        .frame(width: 10, height: 10)
                        .scaleEffect(animPhase == CGFloat(index) ? 1.2 : 0.8)
                        .offset(y: animPhase == CGFloat(index) ? -12 : 0)
                    
                    // Small shadow that shrinks as the dot hops
                    Ellipse()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: animPhase == CGFloat(index) ? 6 : 10, height: 3)
                }
            }
        }
        .onAppear {
            // A timer-based animation for a smoother "wave"
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                    animPhase = (animPhase + 1).truncatingRemainder(dividingBy: 3)
                }
            }
        }
    }
}

struct HoppingDotsLoader: View {
    @State private var dotOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
                    .offset(y: dotOffset)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: dotOffset
                    )
            }
        }
        .onAppear {
            dotOffset = -10
        }
    }
}
