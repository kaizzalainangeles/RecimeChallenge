//
//  MainContainerView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct MainContainerView: View {
    let repository: RecipeRepository
    
    @State private var selectedTab = 0
    @State private var showAddRecipe = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $selectedTab) {
                    
                    // 1. DASHBOARD TAB
                    RecipeDashboardView(repository: repository, selectedTab: $selectedTab)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    // 2. SEARCH TAB
                    ExploreView(repository: repository)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(1)
                    
                    // 3. SAVED TAB
                    Text("Favorites")
                        .tabItem {
                            Label("My Recipes", systemImage: "fork.knife")
                        }
                        .tag(2)
                    
                    // 4. PROFILE TAB
                    Text("Profile Settings")
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(3)
                }
                .tint(.orange) // Sets the active tab color to match ReciMe theme
                
                FloatingAddButton {
                    showAddRecipe = true
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showAddRecipe) {
            RecipeCreateView(
                viewModel: RecipeCreateViewModel(recipeRepository: repository)
            )
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
