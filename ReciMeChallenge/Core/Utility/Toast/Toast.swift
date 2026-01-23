//
//  Toast.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import SwiftUI

/// Defines the styling (colors and icons) for different types of alerts.
enum ToastStyle {
    case success, error, info
    
    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

/// The data model representing a single toast notification.
struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    
    /// How long the toast stays on screen before automatically dismissing (default is 3 seconds).
    var duration: Double = 3.0
}
