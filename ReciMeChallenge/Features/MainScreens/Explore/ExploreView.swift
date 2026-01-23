//
//  ExploreView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @State private var showFilters = false

    init(repository: RecipeRepository) {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(
                    searchText: $viewModel.searchText,
                    onFilterTap: { showFilters = true }
                )
                .padding(.bottom, 8)
                
                // Replace the old ForEach(Array(viewModel.selectedFilters)...) with:
                if viewModel.criteria.isActive {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if viewModel.criteria.isVegetarian {
                                FilterTagView(text: "Vegetarian", color: .green) {
                                    viewModel.criteria.isVegetarian = false
                                }
                            }
                            
                            if viewModel.criteria.minServings > 1 {
                                FilterTagView(text: "\(viewModel.criteria.minServings)+ Servings", color: .green) {
                                    viewModel.criteria.minServings = 1
                                }
                            }
                            
                            ForEach(Array(viewModel.criteria.includedIngredients), id: \.self) { ingredient in
                                FilterTagView(text: ingredient, color: .green) {
                                    viewModel.criteria.includedIngredients.remove(ingredient)
                                }
                            }
                            
                            ForEach(Array(viewModel.criteria.excludedIngredients), id: \.self) { ingredient in
                                FilterTagView(text: ingredient, color: .red) {
                                    viewModel.criteria.excludedIngredients.remove(ingredient)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }

                if viewModel.searchText.isEmpty && !viewModel.criteria.isActive && !viewModel.filteredRecipes.isEmpty {
                    Text("Popular Recipes")
                        .font(Font.title2.bold())
                        .padding([.vertical, .horizontal])
                }
                
                if viewModel.filteredRecipes.isEmpty {
                    ContentUnavailableView(
                        "Discover Recipes",
                        systemImage: "magnifyingglass",
                        description: Text("Search for ingredients or dish names")
                    )
                } else {
                    RecipeGridView(
                        recipes: viewModel.filteredRecipes,
                        isLoadingMore: viewModel.isLoadingPage,
                        onReachEnd: {
                            viewModel.loadNextPage()
                        }
                    )
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showFilters) {
            FilterSheetView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}


#Preview {
    let previewPersistence = RecipePersistenceService()
    let previewNetwork = MockRecipeService()
    
    let previewAuth = AuthService()
    
    
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )

    ExploreView(repository: previewRepo)
}
