//
//  ToastModifier.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import SwiftUI

/// A custom modifier that manages the presentation lifecycle of a toast notification.
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    
    /// Holds a reference to the scheduled dismissal task so it can be cancelled if a new toast arrives.
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) { // Places the toast at the top of the screen
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
                                dismissToast() // Allow user to manually dismiss by tapping
                            }
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: toast)
            }
            // Watch for changes in the toast binding to trigger the timer
            .onChange(of: toast) { oldValue, newValue in
                if newValue != nil {
                    showToast()
                }
            }
    }
    
    /// Prepares and displays the toast, including haptics and auto-dismiss timer.
    private func showToast() {
        guard let toast = toast else { return }
        
        // Trigger a light vibration when the toast appears
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Cancel any existing timer to prevent early dismissal of the new toast
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        
        workItem = task
        // Schedule the auto-dismiss based on the toast's specific duration
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
    
    /// Hides the toast and cleans up the background tasks.
    private func dismissToast() {
        withAnimation(.easeInOut(duration: 0.2)) {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    /// Method to apply the toast modifier
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
