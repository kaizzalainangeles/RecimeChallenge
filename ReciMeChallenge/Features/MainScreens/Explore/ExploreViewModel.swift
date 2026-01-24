//
//  ExploreViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine
import SwiftUI

/// Handles the filtering, searching, and pagination logic for the Explore screen.
@MainActor
class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoadingPage: Bool = false
    @Published var criteria = RecipeFilterCriteria()
    
    private var allRecipes: [Recipe] = []
    private var currentPage = 1
    private let pageSize = 10
    private let recipeRepository: RecipeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
        
        // 1. Sync with the Source of Truth
        recipeRepository.recipesPublisher
            .sink { [weak self] in
                self?.allRecipes = $0
                self?.updateSearchResults()
            }
            .store(in: &cancellables)
        
        // 2. Reactive Search Logic
        // CombineLatest watches both the search bar and the filter sheet
        Publishers.CombineLatest($searchText, $criteria)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Wait for user to stop typing
            .sink { [weak self] _ in
                self?.resetAndSearch()
            }
            .store(in: &cancellables)
    }

    func resetAndSearch() {
        currentPage = 1
        updateSearchResults()
    }
    
    /// Applies filters and handles the data for the current page.
    private func updateSearchResults() {
        let results = allRecipes.filter { matches($0) }
        let limit = min(currentPage * pageSize, results.count)
        
        withAnimation {
            filteredRecipes = Array(results[0..<limit])
        }
    }

    /// The main filtering function
    private func matches(_ recipe: Recipe) -> Bool {
        // 1. Text Search
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            let content = (recipe.title + recipe.description + recipe.instructions.joined()).lowercased()
            guard content.contains(query) else { return false }
        }

        // 2. Dietary Attributes
        let attr = recipe.dietaryAttributes
        if criteria.isVegetarian && !(attr.isVegetarian ?? false) { return false }
        if criteria.isVegan && !(attr.isVegan ?? false) { return false }
        if criteria.isGlutenFree && !(attr.isGlutenFree ?? false) { return false }
        if criteria.isSugarFree && !(attr.isSugarFree ?? false) { return false }

        // 3. Servings
        if recipe.servings < criteria.minServings { return false }

        // 4. Ingredients
        let recipeIngredientNames = recipe.ingredients.map { $0.name.lowercased() }
        
        // Check Exclusions (Fail fast if an "avoid" ingredient is found)
        let hasExcluded = !criteria.excludedIngredients.isDisjoint(with: Set(recipeIngredientNames))
        if hasExcluded { return false }
        
        // Check Inclusions (Must contain ALL specified ingredients)
        if !criteria.includedIngredients.isEmpty {
            let allIncludedPresent = criteria.includedIngredients.allSatisfy { included in
                recipeIngredientNames.contains { $0.contains(included.lowercased()) }
            }
            if !allIncludedPresent { return false }
        }

        return true
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
