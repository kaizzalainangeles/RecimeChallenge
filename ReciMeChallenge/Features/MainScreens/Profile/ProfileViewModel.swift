//
//  ProfileViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {    
    @Published var recipeCount: Int = 0
    
    // The UI associated to this is for display purpose only
    @Published var notificationsEnabled: Bool = true

    let currentUser: User

    private let repository: RecipeRepository
    private let authService: AuthService
    private let toastManager: ToastManager

    init(repository: RecipeRepository, authService: AuthService, toastManager: ToastManager) {
        self.repository = repository
        self.authService = authService
        self.toastManager = toastManager
        
        self.currentUser = authService.currentUser
        
        // Observe the repository to keep the recipe count in sync
        repository.recipesPublisher
            .map { recipes in
                recipes.filter { $0.creatorId != nil }.count
            }
            .assign(to: &$recipeCount)
    }
    
    // The UI associated to this is for display purpose only
    func onSignOutTapped() {
        toastManager.show(style: .success, message: "Sign out tapped!")
    }
    
    // The UI associated to this is for display purpose only
    func onSettingsTapped() {
        toastManager.show(style: .info, message: "Settings tapped!")
    }
}
