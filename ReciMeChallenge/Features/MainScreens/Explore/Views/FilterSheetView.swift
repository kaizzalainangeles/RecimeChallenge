//
//  FilterSheetView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

/// A modal screen that allows users to modify recipe search results based on specific criteria.
struct FilterSheetView: View {
    // Shared state from the Explore screen to keep filters in sync
    @ObservedObject var viewModel: ExploreViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var includeInput = ""
    @State private var excludeInput = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Dietary Preferences") {
                    Toggle("Vegetarian Only", isOn: $viewModel.criteria.isVegetarian)
                        .tint(.orange)
                    
                    Toggle("Vegan Only", isOn: $viewModel.criteria.isVegan)
                        .tint(.orange)
                    
                    Toggle("Gluten-free Only", isOn: $viewModel.criteria.isGlutenFree)
                        .tint(.orange)
                    
                    Toggle("Sugar-free Only", isOn: $viewModel.criteria.isSugarFree)
                        .tint(.orange)
                }
                
                Section("Minimum Servings") {
                    Stepper("At least \(viewModel.criteria.minServings) servings", value: $viewModel.criteria.minServings, in: 1...20)
                }
                
                Section("Include Ingredients") {
                    TextField("Add ingredient to include...", text: $includeInput)
                        .onSubmit {
                            if !includeInput.isEmpty {
                                viewModel.criteria.includedIngredients.insert(includeInput.lowercased())
                                includeInput = ""
                            }
                        }
                    
                    if !viewModel.criteria.includedIngredients.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(Array(viewModel.criteria.includedIngredients), id: \.self) { ing in
                                FilterTagView(text: ing, color: .green) {
                                    viewModel.criteria.includedIngredients.remove(ing)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Exclude Ingredients") {
                    TextField("Add ingredient to avoid...", text: $excludeInput)
                        .onSubmit {
                            if !excludeInput.isEmpty {
                                viewModel.criteria.excludedIngredients.insert(excludeInput.lowercased())
                                excludeInput = ""
                            }
                        }
                    
                    if !viewModel.criteria.excludedIngredients.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(Array(viewModel.criteria.excludedIngredients), id: \.self) { ing in
                                FilterTagView(text: ing, color: .red) {
                                    viewModel.criteria.excludedIngredients.remove(ing)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.criteria = RecipeFilterCriteria()
                    }
                }
            }
        }
    }
}

#Preview {
    let previewPersistence = RecipeCoreDataStorage()
    let previewNetwork = FetchRecipeService()
    
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )
    
    let previewViewModel = ExploreViewModel(recipeRepository: previewRepo)
    
    FilterSheetView(viewModel: previewViewModel)
}
