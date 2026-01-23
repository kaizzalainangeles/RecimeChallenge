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
    // The UI associated to this is for display purpose only
    @Published var notificationsEnabled: Bool = true
    
    @Published var recipeCount: Int = 0

    let currentUser: User

    private let recipeRepository: RecipeRepositoryProtocol
    private let toastManager: ToastManager

    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        self.recipeRepository = recipeRepository
        self.toastManager = toastManager
        
        self.currentUser = authService.currentUser
        
        // Observe the repository to keep the recipe count in sync
        recipeRepository.recipesPublisher
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
    
    // The UI associated to this is for display purpose only
    func onNotificationToggle() {
        toastManager.show(style: .info, message: "Notifications toggled!")
    }
}
