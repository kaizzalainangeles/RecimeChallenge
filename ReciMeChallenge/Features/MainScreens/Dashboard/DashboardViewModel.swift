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
    
    private let repository: RecipeRepository
    private let authService: AuthService = .shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: RecipeRepository) {
        self.repository = repository
        
        // Subscribe to repository changes
        repository.recipesPublisher
            .sink { [weak self] recipes in
                self?.allRecipes = recipes
                self?.selectRandomFeatured()
                self?.selectOwnedRecipes()
            }
            .store(in: &cancellables)
    }
    
    func selectRandomFeatured() {
        featuredRecipes = Array(allRecipes.shuffled().prefix(5))
    }
    
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
        await repository.sync()
    }
}
