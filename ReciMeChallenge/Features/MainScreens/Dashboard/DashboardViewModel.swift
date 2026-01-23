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
    @Published var searchText: String = ""
    
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
    
    // Select 5 random recipes to display for featured recipes
    func selectRandomFeatured() {
        featuredRecipes = Array(allRecipes.shuffled().prefix(5))
    }
    
    // Select 5 random owned recipes to display
    func selectOwnedRecipes() {
        let creatorId = authService.currentUserId
        let recipesWithSameCreatorId = allRecipes.filter { $0.creatorId == creatorId }
        
        ownedRecipes = Array(recipesWithSameCreatorId.shuffled().prefix(5))
    }
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return allRecipes
        } else {
            return allRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func refreshData() async {
        do {
            try await recipeRepository.sync()
        } catch {
            toastManager.show(style: .error, message: error.localizedDescription)
        }
    }
    
    func onLogoButtonTapped() {
        toastManager.show(style: .success, message: "Logo tapped!")
    }
    
    func onNotificationBellTapped() {
        toastManager.show(style: .success, message: "Notification tapped!")
    }
}
