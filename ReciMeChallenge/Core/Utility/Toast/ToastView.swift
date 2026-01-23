//
//  ToastView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon with a subtle circular background
            Image(systemName: style.icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(style.color.gradient) // Uses modern SwiftUI gradients
                .clipShape(Circle())
            
            Text(message)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.leading, 8)
        .padding(.trailing, 20)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        }
        .overlay {
            Capsule()
                .strokeBorder(style.color.opacity(0.1), lineWidth: 1)
        }
        .padding(.horizontal, 24)
        .fixedSize(horizontal: false, vertical: true)
    }
}
