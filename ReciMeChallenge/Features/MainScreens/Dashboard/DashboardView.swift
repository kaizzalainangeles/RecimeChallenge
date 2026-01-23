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
    
    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager, selectedTab: Binding<Tab>) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(
            recipeRepository: recipeRepository,
            authService: authService,
            toastManager: toastManager
        ))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                UpperGradientView()
                
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
                .refreshable {
                    await viewModel.refreshData()
                }
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: viewModel.onLogoButtonTapped) {
                        Image("SplashLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.orange.gradient)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // This is for display purpose only
                    Button(action: viewModel.onNotificationBellTapped) {
                        Image(systemName: "bell.fill")
                    }
                    .badge(1)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .task {
                await viewModel.refreshData()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hello, Chef! 👋")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Text("Discover Recipes")
                .font(.system(.largeTitle, design: .rounded).bold())
        }
        .padding(.horizontal)
    }
}

#Preview {
    let previewPersistence = RecipeCoreDataStorage()
    let previewNetwork = FetchRecipeService()
    let previewRepo = RecipeRepository(
        recipeService: previewNetwork,
        persistence: previewPersistence
    )
    
    let previewAuth = AuthService()
    let previewToast = ToastManager()
    
    RecipeDashboardView(
        recipeRepository: previewRepo,
        authService: previewAuth,
        toastManager: previewToast,
        selectedTab: .constant(.home)
    )
}
