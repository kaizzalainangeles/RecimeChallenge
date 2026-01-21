//
//  ExploreViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine
import SwiftUI

enum DietaryFilter: String, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten Free"
}

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoadingPage: Bool = false
    @Published var selectedFilters: Set<DietaryFilter> = []
    
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
        
        // React to search text changes with a debounce (prevents flickering while typing)
        $searchText
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

    func loadNextPage() {
        guard !isLoadingPage && !searchText.isEmpty else { return }
        
        // Check if there is more data to load
        let totalFiltered = allRecipes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }.count
        
        if filteredRecipes.count < totalFiltered {
            isLoadingPage = true
            
            // Simulate network delay for a smoother feel
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.currentPage += 1
                self.updateSearchResults()
                self.isLoadingPage = false
            }
        }
    }
    
    private func updateSearchResults() {
        // 1. Initial Filter by Search Text
        var results = allRecipes.filter { recipe in
            searchText.isEmpty ||
            recipe.title.localizedCaseInsensitiveContains(searchText) ||
            recipe.description.localizedCaseInsensitiveContains(searchText)
        }

        // 2. Apply Dietary Filters from the Set
        if !selectedFilters.isEmpty {
            results = results.filter { recipe in
                selectedFilters.allSatisfy { filter in
                    switch filter {
                    case .vegetarian: return recipe.dietaryAttributes.isVegetarian == true
                    case .vegan: return recipe.dietaryAttributes.isVegan == true
                    case .glutenFree: return recipe.dietaryAttributes.isGlutenFree == true
                    }
                }
            }
        }

        // 3. Apply Pagination
        let limit = min(currentPage * pageSize, results.count)
        withAnimation {
            filteredRecipes = Array(results[0..<limit])
        }
    }
    
    func toggleFilter(_ filter: DietaryFilter) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
        resetAndSearch()
    }
}
