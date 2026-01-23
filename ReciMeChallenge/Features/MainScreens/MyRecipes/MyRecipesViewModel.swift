//
//  MyRecipesViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import Foundation
import Combine

@MainActor
class MyRecipesViewModel: ObservableObject {
    @Published var myRecipes: [Recipe] = []
    @Published var searchText: String = ""
    
    private let recipeRepository: RecipeRepository
    private let authService: AuthService
    private let toastManager: ToastManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipeRepository: RecipeRepository, authService: AuthService, toastManager: ToastManager) {
        self.recipeRepository = recipeRepository
        self.authService = authService
        self.toastManager = toastManager
        
        recipeRepository.recipesPublisher
            .sink { [weak self] allRecipes in
                let currentUserId = self?.authService.currentUserId
                self?.myRecipes = allRecipes.filter { $0.creatorId == currentUserId }
            }
            .store(in: &cancellables)
    }
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return myRecipes
        } else {
            return myRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipeRepository.deleteRecipe(recipe)
        toastManager.show(style: .success, message: "Recipe deleted successfully.")
    }
}
