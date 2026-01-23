//
//  RecipeSectionView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct RecipeSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content
            Divider()
        }
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .font(.body)
            Spacer()
            Text(ingredient.quantity)
                .font(.subheadline.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

struct InstructionStepRow: View {
    let index: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(index + 1)")
                .font(.title3.bold())
                .foregroundColor(.orange)
                .frame(width: 32, height: 32)
                .background(Color.orange.opacity(0.1))
                .clipShape(Circle())
            
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
