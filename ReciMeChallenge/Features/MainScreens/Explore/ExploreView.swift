//
//  ExploreView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel: ExploreViewModel
    @State private var showFilters = false

    init(repository: RecipeRepository) {
        _viewModel = StateObject(wrappedValue: ExploreViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(
                    searchText: $viewModel.searchText,
                    shouldFocusOnAppear: true,
                    onFilterTap: { showFilters = true }
                )
                .padding(.bottom, 8)
                
                if !viewModel.selectedFilters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(viewModel.selectedFilters), id: \.self) { filter in
                                HStack {
                                    Text(filter.rawValue)
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .clipShape(Capsule())
                                .onTapGesture { viewModel.toggleFilter(filter) }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }

                if viewModel.searchText.isEmpty {
                    ContentUnavailableView(
                        "Discover Recipes",
                        systemImage: "magnifyingglass",
                        description: Text("Search for ingredients or dish names")
                    )
                } else {
                    RecipeGridView(
                        recipes: viewModel.filteredRecipes,
                        isLoadingMore: viewModel.isLoadingPage,
                        onReachEnd: {
                            viewModel.loadNextPage()
                        }
                    )
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterSheetView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}


struct RecipeGridView: View {
    let recipes: [Recipe]
    var isLoadingMore: Bool = false
    var onReachEnd: (() -> Void)? = nil // Pagination trigger
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(recipes) { recipe in
                    NavigationLink(value: recipe) {
                        SmallRecipeCard(recipe: recipe)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        // If this is the last recipe, trigger pagination
                        if recipe == recipes.last {
                            onReachEnd?()
                        }
                    }
                }
                
                if isLoadingMore {
                    Section(footer: HoppingDotsLoader().frame(maxWidth: .infinity).padding()) {
                        EmptyView()
                    }
                }
            }
            .padding()
        }
    }
}

struct SmallRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // IMAGE SECTION
            ZStack {
                if let url = recipe.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            noImagePlaceholder // Show icon if URL fails
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.05)
                                HoppingDotsLoader()
                            }
                        @unknown default:
                            noImagePlaceholder
                        }
                    }
                    .frame(width: 150, height: 150)
                    .frame(maxWidth: .infinity)
                    .clipped()
                } else {
                    noImagePlaceholder // Show icon if URL is nil
                }
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity) // Ensures it fills the grid column width
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15)) // Prevents overlap!
            
            // TEXT SECTION
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(recipe.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 4)
        }
        .contentShape(Rectangle()) // Makes the whole card tappable
    }
    
    private var noImagePlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "fork.knife")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

struct FilterSheetView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("DIETARY PREFERENCES")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    VStack(spacing: 0) {
                        ForEach(DietaryFilter.allCases, id: \.self) { filter in
                            filterRow(for: filter)
                            
                            if filter != DietaryFilter.allCases.last {
                                Divider().padding(.leading)
                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !viewModel.selectedFilters.isEmpty {
                        Button("Clear All") {
                            viewModel.selectedFilters.removeAll()
                            viewModel.resetAndSearch()
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func filterRow(for filter: DietaryFilter) -> some View {
        let isSelected = viewModel.selectedFilters.contains(filter)
        
        HStack {
            Text(filter.rawValue)
                .foregroundColor(.primary)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.orange : Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if isSelected {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 14, height: 14)
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleFilter(filter)
        }
    }
}
