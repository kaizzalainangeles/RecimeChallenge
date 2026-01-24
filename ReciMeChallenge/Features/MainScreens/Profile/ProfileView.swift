//
//  ProfileView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import SwiftUI

/// The screen representing the user's account and app preferences.
struct ProfileView: View {
    @EnvironmentObject var toastManager: ToastManager
    @StateObject var viewModel: ProfileViewModel
    @Binding var selectedTab: Tab
    
    init(
        recipeRepository: RecipeRepositoryProtocol,
        authService: AuthServiceProtocol,
        toastManager: ToastManager,
        selectedTab: Binding<Tab>)
    {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(
            recipeRepository: recipeRepository,
            authService: authService,
            toastManager: toastManager
        ))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            List {
                // 1. PROFILE HEADER
                Section {
                    ProfileHeaderView(currentUser: viewModel.currentUser)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                // 2. USER STATS BANNERS
                Section {
                    StatusSectionView(
                        recipeCount: viewModel.recipeCount,
                        followers: viewModel.currentUser.followers,
                        likes: viewModel.currentUser.likes
                    )
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                // 3. RECIPE MANAGEMENT
                Section("My Kitchen") {
                    Label("My Recipes", systemImage: "doc.text")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTab = .recipes
                        }
                }

                // 4. PREFERENCES - This is for display purpose only
                Section("Preferences") {
                    Toggle(isOn: $viewModel.notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    .onChange(of: viewModel.notificationsEnabled) {
                        viewModel.onNotificationToggle()
                    }
                    .tint(.orange)
                }

                // 5. ACCOUNT ACTIONS - This is for display purpose only
                Section {
                    Button(role: .destructive, action: viewModel.onSignOutTapped) {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                // This is for display purpose only
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.onSettingsTapped) {
                        Image(systemName: "gearshape")
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

    let previewAuth = AuthService()
    let previewToast = ToastManager()
    
    ProfileView(
        recipeRepository: previewRepo,
        authService: previewAuth,
        toastManager: previewToast,
        selectedTab: .constant(.profile)
    )
    .environmentObject(previewToast)
}
