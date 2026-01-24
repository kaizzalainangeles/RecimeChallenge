//
//  MainContainerView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

/// The root view of the application that manages the TabView and global overlays.
struct MainContainerView: View {
    // MARK: - Dependencies
    let recipeRepository: RecipeRepositoryProtocol
    let authService: AuthServiceProtocol
    
    // MARK: - State Management
    @StateObject private var toastManager = ToastManager()
    @State private var selectedTab: Tab = .home
    @State private var showAddRecipe = false
    @State private var activeToast: Toast? = nil
    
    var body: some View {
        // GeometryReader helps position the Floating Create Button
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $selectedTab) {
                    // 1. DASHBOARD TAB
                    RecipeDashboardView(
                        recipeRepository: recipeRepository,
                        authService: authService,
                        toastManager: toastManager,
                        selectedTab: $selectedTab
                    )
                    .tabItem {
                        Label(Tab.home.title, systemImage: Tab.home.icon)
                    }
                    .tag(Tab.home)
                    
                    // 2. SEARCH TAB
                    ExploreView(recipeRepository: recipeRepository)
                        .tabItem {
                            Label(Tab.search.title, systemImage: Tab.search.icon)
                        }
                        .tag(Tab.search)
                    
                    // 3. SAVED TAB
                    MyRecipesView(
                        recipeRepository: recipeRepository,
                        authService: authService,
                        toastManager: toastManager
                    )
                    .tabItem {
                        Label(Tab.recipes.title, systemImage: Tab.recipes.icon)
                    }
                    .tag(Tab.recipes)
                    
                    // 4. PROFILE TAB
                    ProfileView(
                        recipeRepository: recipeRepository,
                        authService: authService,
                        toastManager: toastManager,
                        selectedTab: $selectedTab
                    )
                    .tabItem {
                        Label(Tab.profile.title, systemImage: Tab.profile.icon)
                    }
                    .tag(Tab.profile)
                }
                .defaultAdaptableTabBarPlacement(.tabBar)
                .tint(.orange) // Sets the active tab color to match ReciMe theme
                
                // 2. FLOATING ACTION BUTTON (FAB)
                // Positioned above the TabBar for quick access to adding recipe
                FloatingAddButton {
                    showAddRecipe = true
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toastView(toast: $toastManager.activeToast)
        .sheet(isPresented: $showAddRecipe) {
            RecipeCreateView(
                recipeRepository: recipeRepository,
                authService: authService,
                toastManager: toastManager
            )
        }
        // Allows any child view to access the toastManager without explicit passing
        .environmentObject(toastManager)
    }
}

#Preview {
    let previewPersistence = RecipeCoreDataStorage()
    let previewNetwork = FetchRecipeService()
    let previewAuth = AuthService()
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )

    MainContainerView(recipeRepository: previewRepo, authService: previewAuth)
}
