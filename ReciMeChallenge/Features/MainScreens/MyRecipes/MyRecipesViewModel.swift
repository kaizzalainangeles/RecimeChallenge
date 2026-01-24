//
//  MyRecipesViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import Foundation
import Combine

/// Manages the data and logic for the user's personal recipe collection.
@MainActor
class MyRecipesViewModel: ObservableObject {
    // The filtered list of recipes belonging to the current user
    @Published var myRecipes: [Recipe] = []
    
    private let recipeRepository: RecipeRepositoryProtocol
    private let authService: AuthServiceProtocol
    private let toastManager: ToastManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        self.recipeRepository = recipeRepository
        self.authService = authService
        self.toastManager = toastManager
        
        recipeRepository.recipesPublisher
            .sink { [weak self] allRecipes in
                let currentUserId = self?.authService.currentUserId
                // Only keep recipes where the creator matches the logged-in user
                self?.myRecipes = allRecipes.filter { $0.creatorId == currentUserId }
            }
            .store(in: &cancellables)
    }
    
    /// Triggers a fetch and updates the local repository
    func refreshData() async {
        do {
            try await recipeRepository.sync()
        } catch {
            toastManager.show(style: .error, message: error.localizedDescription)
        }
    }
    
    /// Removes a recipe from the repository
    func deleteRecipe(_ recipe: Recipe) {
        do {
            try recipeRepository.deleteRecipe(recipe)
            toastManager.show(style: .success, message: "Recipe deleted successfully.")
        } catch {
            toastManager.show(style: .error, message: error.localizedDescription)
        }
    }
}
