//
//  ToastModifier.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                Group {
                    if let toast = toast {
                        ToastView(style: toast.style, message: toast.message)
                            .padding(.top, 10)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                                    removal: .opacity.combined(with: .scale(scale: 0.9))
                                )
                            )
                            .onTapGesture {
                                dismissToast()
                            }
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: toast)
            }
            .onChange(of: toast) { oldValue, newValue in
                if newValue != nil {
                    showToast()
                }
            }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
    
    private func dismissToast() {
        withAnimation(.easeInOut(duration: 0.2)) {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}
extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
