//
//  ToastManager.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import Foundation
import Combine

class ToastManager: ObservableObject {
    @Published var activeToast: Toast? = nil
    
    func show(style: ToastStyle, message: String) {
        activeToast = Toast(style: style, message: message)
    }
}
