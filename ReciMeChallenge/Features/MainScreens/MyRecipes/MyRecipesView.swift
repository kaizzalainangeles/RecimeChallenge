//
//  MyRecipesView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/21/26.
//

import SwiftUI

struct MyRecipesView: View {
    @StateObject private var viewModel: MyRecipesViewModel
    
    @State private var recipeToDelete: Recipe?
    @State private var showDeleteConfirmation = false

    private let columns = [
        GridItem(.adaptive(minimum: 170, maximum: .infinity), spacing: 16)
    ]
    
    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        _viewModel = StateObject(wrappedValue: MyRecipesViewModel(
            recipeRepository: recipeRepository,
            authService: authService,
            toastManager: toastManager
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                UpperGradientView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(viewModel.myRecipes.count)")
                                    .font(.title.bold())
                                Text("Total Recipes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.orange.opacity(0.8))
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        if viewModel.myRecipes.isEmpty {
                            emptyStateView
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.filteredRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        RecipeCardView(recipe: recipe, style: .minimal(context: .myRecipes))
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            recipeToDelete = recipe
                                            showDeleteConfirmation = true
                                        } label: {
                                            Label("Delete Recipe", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await viewModel.refreshData()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Recipes")
            .alert("Delete Recipe?", isPresented: $showDeleteConfirmation, presenting: recipeToDelete) { recipe in
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.deleteRecipe(recipe)
                    }
                }
                Button("Cancel", role: .cancel) {
                    recipeToDelete = nil
                }
            } message: { recipe in
                Text("Are you sure you want to delete '\(recipe.title)'? This action cannot be undone.")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 50)
            Text("No Recipes Yet")
                .font(.headline)
            Text("Start creating your own personal cookbook by tapping the + button.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
    

    MyRecipesView(
        recipeRepository: previewRepo,
        authService: previewAuth,
        toastManager: previewToast
    )
}
