//
//  AuthService.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    // In a real app, this would be fetched after login
    @Published var currentUserId: String
    
    private init() {
        // Check if we already have a stored ID, otherwise create a new one
        if let storedId = UserDefaults.standard.string(forKey: "current_user_id") {
            self.currentUserId = storedId
        } else {
            let newId = "user_17"
            UserDefaults.standard.set(newId, forKey: "current_user_id")
            self.currentUserId = newId
        }
    }
}
