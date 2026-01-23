//
//  StatusSectionView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct StatusSectionView: View {
    let recipeCount: Int
    let followers: Int
    let likes: Int
    
    var body: some View {
        HStack(spacing: 15) {
            StatusCardView(
                title: "Recipes",
                value: recipeCount,
                icon: "fork.knife",
                color: .orange
            )
            
            StatusCardView(
                title: "Followers",
                value: followers,
                icon: "person.2.fill",
                color: .blue
            )
            
            StatusCardView(
                title: "Likes",
                value: likes,
                icon: "heart.fill",
                color: .red
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatusSectionView(recipeCount: 17, followers: 17, likes: 17)
}
