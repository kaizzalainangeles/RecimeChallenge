//
//  RecipeListV2.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct RecipeDashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @Binding var selectedTab: Int
    
    init(repository: RecipeRepository, selectedTab: Binding<Int>) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // 1. GREETING
                    headerSection
                    
                    // 2. FEATURED SECTION (Randomly picked by VM)
                    SliderView(
                        title: "Featured for You",
                        recipes: viewModel.featuredRecipes,
                        noRecipesMessage: "No featured recipes available.",
                        onSeeMorePressed: { selectedTab = 2 }
                    )
                    .padding(.bottom)
                    
                    // 3. OWNED RECIPES SECTION (Randomly picked by VM)
                    SliderView(
                        title: "Your Recipe's",
                        recipes: viewModel.ownedRecipes,
                        noRecipesMessage: "You haven't added any recipes yet.",
                        onSeeMorePressed: { selectedTab = 2 } //Switch to My Recipes Tab
                    )
                    .padding(.vertical)
                }
                .padding(.top)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .task {
                await viewModel.refreshData()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                    }
                    .badge(1)
                }
            }
        }
    }
    
    // Sub-views for better organization
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hello, Chef! 👋")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("Discover Recipes")
                .font(.largeTitle.bold())
        }
        .padding(.horizontal)
    }
    
    private var searchSection: some View {
        SearchBarView(searchText: $viewModel.searchText, onFilterTap: {})
            .overlay(
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation() {
                            selectedTab = 1 // Switch to Search Tab
                        }
                    }
            )
    }
    
    private var recipeListSection: some View {
        VStack(alignment: .leading) {
            Text("Explore More").font(.headline).padding(.horizontal)
            
            ForEach(viewModel.filteredRecipes) { recipe in
                // Small Row View for other recipes
                Text(recipe.title).padding()
            }
        }
    }
}

#Preview {
    let mockPersistence = RecipePersistenceService()
    let mockNetwork = MockRecipeService()
    
    let previewRepo = RecipeRepository(
        recipeService: mockNetwork,
        persistence: mockPersistence
    )
    
    MainContainerView(repository: previewRepo)
}
