//
//  ExploreViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoadingPage: Bool = false
    @Published var criteria = RecipeFilterCriteria()
    
    private var allRecipes: [Recipe] = []
    private var currentPage = 1
    private let pageSize = 10
    private let repository: RecipeRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: RecipeRepository) {
        self.repository = repository
        
        repository.recipesPublisher
            .sink { [weak self] in
                self?.allRecipes = $0
                self?.updateSearchResults()
            }
            .store(in: &cancellables)
        
        // Listen to both searchText and criteria changes
        Publishers.CombineLatest($searchText, $criteria)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetAndSearch()
            }
            .store(in: &cancellables)
    }

    func resetAndSearch() {
        currentPage = 1
        updateSearchResults()
    }

    private func updateSearchResults() {
        let results = allRecipes.filter { recipe in
            // 1. Title + Description + Instruction + Content Search
            let matchesSearch = searchText.isEmpty ||
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.description.localizedCaseInsensitiveContains(searchText) ||
                recipe.instructions.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            
            // 2. Dietary Filters
            let matchesVegetarian = !criteria.isVegetarian || (recipe.dietaryAttributes.isVegetarian ?? false)
            
            // 3. Servings Filter (Requirement)
            let matchesServings = recipe.servings >= criteria.minServings
            
            // 4. Ingredients Include/Exclude (Requirement)
            let recipeIngredientsNames = recipe.ingredients.map { $0.name.lowercased() }
            
            let matchesIncludedIngredients = criteria.includedIngredients.isEmpty ||
                criteria.includedIngredients.allSatisfy { included in
                    recipeIngredientsNames.contains { $0.contains(included.lowercased()) }
                }
            
            let matchesExcludedIngredients = criteria.excludedIngredients.isDisjoint(with: Set(recipeIngredientsNames))

            return matchesSearch && matchesVegetarian && matchesServings && matchesIncludedIngredients && matchesExcludedIngredients
        }

        let limit = min(currentPage * pageSize, results.count)
        
        withAnimation {
            filteredRecipes = Array(results[0..<limit])
        }
    }
    
    func loadNextPage() {
        guard !isLoadingPage && !searchText.isEmpty else { return }
        
        if filteredRecipes.count < allRecipes.count { // Simplified check for brevity
            isLoadingPage = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                self.currentPage += 1
                self.updateSearchResults()
                self.isLoadingPage = false
            }
        }
    }
}

struct RecipeFilterCriteria: Equatable {
    var isVegetarian: Bool = false
    var minServings: Int = 1
    var includedIngredients: Set<String> = []
    var excludedIngredients: Set<String> = []
    
    // Helper to check if any filter is active (to show a badge)
    var isActive: Bool {
        isVegetarian || minServings > 1 || !includedIngredients.isEmpty || !excludedIngredients.isEmpty
    }
}
