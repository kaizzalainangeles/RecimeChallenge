//
//  FilterSheetView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import SwiftUI

struct FilterSheetView: View {
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
    let previewPersistence = RecipePersistenceService()
    let previewNetwork = MockRecipeService()
    
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )
    
    let previewViewModel = ExploreViewModel(repository: previewRepo)
    
    FilterSheetView(viewModel: previewViewModel)
}
