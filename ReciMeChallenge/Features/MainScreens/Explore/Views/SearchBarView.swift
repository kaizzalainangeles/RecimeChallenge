//
//  SearchBarView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onFilterTap: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search recipes...", text: $searchText)
            
            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""), onFilterTap: {})
}
