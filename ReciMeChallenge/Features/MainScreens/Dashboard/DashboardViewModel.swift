//
//  DashboardViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var featuredRecipes: [Recipe] = []
    @Published var ownedRecipes: [Recipe] = []
    @Published var allRecipes: [Recipe] = []
    
    private let recipeRepository: RecipeRepositoryProtocol
    private let authService: AuthServiceProtocol
    private let toastManager: ToastManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        self.recipeRepository = recipeRepository
        self.authService = authService
        self.toastManager = toastManager
        
        // Subscribe to repository changes
        recipeRepository.recipesPublisher
            .sink { [weak self] recipes in
                self?.allRecipes = recipes
                self?.selectRandomFeatured()
                self?.selectOwnedRecipes()
            }
            .store(in: &cancellables)
    }
    
    /// Randomly selects 5 recipes to show in the "Featured" section to keep the UI fresh.
    func selectRandomFeatured() {
        featuredRecipes = Array(allRecipes.shuffled().prefix(5))
    }
    
    /// Filters the main list to find recipes belonging to the "logged-in" user.
    func selectOwnedRecipes() {
        let creatorId = authService.currentUserId
        let recipesWithSameCreatorId = allRecipes.filter { $0.creatorId == creatorId }
        
        ownedRecipes = Array(recipesWithSameCreatorId.shuffled().prefix(5))
    }
    
    /// Triggers a fetch and updates the local repository.
    func refreshData() async {
        do {
            try await recipeRepository.sync()
        } catch {
            toastManager.show(style: .error, message: error.localizedDescription)
        }
    }
}


/// Methods used for "display-only" UI
extension DashboardViewModel {
    func onLogoButtonTapped() {
        toastManager.show(style: .success, message: "Logo tapped!")
    }
    
    func onNotificationBellTapped() {
        toastManager.show(style: .success, message: "Notification tapped!")
    }
}
