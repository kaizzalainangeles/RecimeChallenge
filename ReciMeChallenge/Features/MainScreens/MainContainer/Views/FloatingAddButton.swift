//
//  FloatingAddButton.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

/// A circular button that floats in the bottom-right corner, used to trigger the "Create Recipe" flow.
struct FloatingAddButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .padding()
                        .background(Circle().fill(Color.orange))
                        .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    FloatingAddButton(action: {})
}
