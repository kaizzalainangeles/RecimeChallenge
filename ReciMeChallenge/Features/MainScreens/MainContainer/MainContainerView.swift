//
//  MainContainerView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct MainContainerView: View {
    let repository: RecipeRepositoryProtocol
    let authService: AuthServiceProtocol
    
    @StateObject private var toastManager = ToastManager()
    
    @State private var selectedTab: Tab = .home
    @State private var showAddRecipe = false
    @State private var activeToast: Toast? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $selectedTab) {
                    
                    // 1. DASHBOARD TAB
                    RecipeDashboardView(
                        repository: repository,
                        authService: authService,
                        toastManager: toastManager,
                        selectedTab: $selectedTab
                    )
                    .tabItem {
                        Label(Tab.home.title, systemImage: Tab.home.icon)
                    }
                    .tag(Tab.home)
                    
                    // 2. SEARCH TAB
                    ExploreView(repository: repository)
                        .tabItem {
                            Label(Tab.search.title, systemImage: Tab.search.icon)
                        }
                        .tag(Tab.search)
                    
                    // 3. SAVED TAB
                    MyRecipesView(
                        repository: repository,
                        authService: authService,
                        toastManager: toastManager
                    )
                    .tabItem {
                        Label(Tab.recipes.title, systemImage: Tab.recipes.icon)
                    }
                    .tag(Tab.recipes)
                    
                    // 4. PROFILE TAB
                    ProfileView(
                        repository: repository,
                        authService: authService,
                        toastManager: toastManager,
                        selectedTab: $selectedTab
                    )
                    .tabItem {
                        Label(Tab.profile.title, systemImage: Tab.profile.icon)
                    }
                    .tag(Tab.profile)
                }
                .tint(.orange) // Sets the active tab color to match ReciMe theme
                
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
                viewModel: RecipeCreateViewModel(
                    recipeRepository: repository,
                    authService: authService,
                    toastManager: toastManager
                )
            )
        }
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

    MainContainerView(repository: previewRepo, authService: previewAuth)
}
