//
//  HoppingDotsLoader.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

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

#Preview {
    HoppingDotsLoader()
}
