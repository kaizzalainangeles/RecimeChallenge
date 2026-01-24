//
//  ProfileViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import Foundation
import Combine

/// Manages data for the Profile screen, providing user info and placeholder actions.
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
    
    // MARK: - Placeholder Actions
    // These functions simulate real app logic by providing visual feedback via Toasts.
    
    /// Triggers a success toast when the user attempts to sign out.
    func onSignOutTapped() {
        toastManager.show(style: .success, message: "Sign out tapped!")
    }
    
    /// Triggers an info toast for the settings gear icon.
    func onSettingsTapped() {
        toastManager.show(style: .info, message: "Settings tapped!")
    }
    
    /// Triggers an info toast when the notification toggle is switched.
    func onNotificationToggle() {
        toastManager.show(style: .info, message: "Notifications toggled!")
    }
}
