//
//  Toast.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.icon)
                .foregroundColor(style.color)
                .font(.title3)
            
            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial) // Modern frosted glass effect
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style.color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if let toast = toast {
                        VStack {
                            ToastView(style: toast.style, message: toast.message)
                            Spacer() // Push to top
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: toast)
                    }
                }
                .padding(.top, 10) // Position below safe area/notch
            )
            .onChange(of: toast) { _ in
                showToast()
            }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            withAnimation {
                self.toast = nil
            }
        }
        
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
