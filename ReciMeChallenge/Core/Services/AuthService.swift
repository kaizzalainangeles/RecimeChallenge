//
//  AuthService.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    var currentUserId: String { get }
    var currentUser: User { get }
}

/// A "mock" service to simulate user data fetching and storing
class AuthService: ObservableObject, AuthServiceProtocol {
    var currentUserId: String
    var currentUser: User
    
    init() {
        // Check if we already have a stored ID, otherwise create a new one
        if let storedId = UserDefaults.standard.string(forKey: "current_user_id") {
            self.currentUserId = storedId
        } else {
            let newId = "user_17"
            UserDefaults.standard.set(newId, forKey: "current_user_id")
            self.currentUserId = newId
        }
        
        currentUser = User(
            id: currentUserId,
            userName: "Chef Kaizz",
            email: "angeleskaizz@gmail.com",
            userBio: "Home Cook",
            followers: 17,
            likes: 17
        )
    }
}
