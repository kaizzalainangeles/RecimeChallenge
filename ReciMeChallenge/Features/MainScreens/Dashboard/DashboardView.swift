//
//  RecipeListV2.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

enum RecipeGroupType {
    case featured
    case owned
}

struct RecipeDashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @Binding var selectedTab: Tab
    
    init(repository: RecipeRepository, authService: AuthService, toastManager: ToastManager, selectedTab: Binding<Tab>) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(
            repository: repository,
            authService: authService,
            toastManager: toastManager
        ))
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
                        title: "Featured",
                        recipes: viewModel.featuredRecipes,
                        recipeGroupType: .featured,
                        onSeeMorePressed: { selectedTab = .search } // Switch to Search Tab
                    )
                    .padding(.bottom)
                    
                    // 3. OWNED RECIPES SECTION (Randomly picked by VM)
                    SliderView(
                        title: "My Recipe's",
                        recipes: viewModel.ownedRecipes,
                        recipeGroupType: .owned,
                        onSeeMorePressed: { selectedTab = .recipes } // Switch to My Recipes Tab
                    )
                    .padding(.vertical)
                }
                .padding(.top)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // This is for display purpose only
                    Button(action: viewModel.onNotificationBellTapped) {
                        Image(systemName: "bell.fill")
                    }
                    .badge(1)
                }
            }
            .task {
                await viewModel.refreshData()
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
}

#Preview {
    let previewPersistence = RecipePersistenceService()
    let previewNetwork = MockRecipeService()
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )
    
    let previewAuth = AuthService()
    let previewToast = ToastManager()
    
    RecipeDashboardView(
        repository: previewRepo,
        authService: previewAuth,
        toastManager: previewToast,
        selectedTab: .constant(.home)
    )
}
