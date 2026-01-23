//
//  RecipeCreateView.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI
import PhotosUI

struct RecipeCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: RecipeCreateViewModel
    
    @FocusState private var focusedField: Field?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var previewImage: UIImage? = nil
    
    enum Field {
        case title, description, ingredient, instruction
    }
    
    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        _viewModel = StateObject(wrappedValue: RecipeCreateViewModel(
            recipeRepository: recipeRepository,
            authService: authService,
            toastManager: toastManager
        ))
    }

    var body: some View {
        NavigationStack {
            Form {
                imagePickerSection
                basicInfoSection
                dietaryInfoSection
                ingredientsSection
                instructionsSection
                validationFooterSection
            }
            .navigationTitle(Constants.newRecipeLabel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Constants.cancelButtonLabel) { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(Constants.saveButtonLabel) {
                        saveRecipe()
                    }
                    .fontWeight(.bold)
                    .disabled(!viewModel.isFormValid())
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var imagePickerSection: some View {
        Section {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    if let uiImage = previewImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 30))
                            Text(Constants.addCoverPhotoLabel)
                                .font(.subheadline.bold())
                        }
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.05))
                        .foregroundColor(.orange)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.orange.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                }
            }
            .onChange(of: selectedItem) { _, newItem in
                viewModel.handleImageSelection(newItem)
            }
            .onReceive(viewModel.$selectedImageData) { data in
                previewImage = data.flatMap { UIImage(data: $0) }
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    private var basicInfoSection: some View {
        Section(Constants.basicInfoSectionLabel) {
            TextField(Constants.recipeTitleLabel, text: $viewModel.title)
                .font(.headline)
                .focused($focusedField, equals: .title)
            
            Stepper(value: $viewModel.servings, in: 1...20) {
                Label("Servings: \(viewModel.servings)", systemImage: "person.2")
            }
            
            TextField(Constants.descriptionLabel, text: $viewModel.description, axis: .vertical)
                .lineLimit(3...5)
                .focused($focusedField, equals: .description)
        }
    }
    
    private var dietaryInfoSection: some View {
        Section(Constants.dietaryInfoSectionLabel) {
            ForEach(DietaryFilter.allCases, id: \.self) { filter in
                Toggle(filter.rawValue, isOn: Binding(
                    get: { viewModel.selectedDietary.contains(filter) },
                    set: { isSelected in
                        if isSelected {
                            viewModel.selectedDietary.insert(filter)
                        }
                        else {
                            viewModel.selectedDietary.remove(filter)
                        }
                    }
                ))
                .tint(.orange)
            }
        }
    }
    
    private var ingredientsSection: some View {
        Section(Constants.ingredientsSectionLabel) {
            ForEach($viewModel.ingredients) { $ingredient in
                HStack {
                    TextField(Constants.quantityLabel, text: $ingredient.quantity)
                        .frame(width: 60)
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                        .focused($focusedField, equals: .ingredient)
                    
                    Divider()
                    
                    TextField(Constants.ingredientNameLabel, text: $ingredient.name)
                        .focused($focusedField, equals: .ingredient)
                }
            }
            .onDelete { viewModel.ingredients.remove(atOffsets: $0) }
            
            Button {
                withAnimation {
                    viewModel.ingredients.append(Ingredient(name: "", quantity: ""))
                }
            } label: {
                Label(Constants.addIngredientButtonLabel, systemImage: "plus.circle.fill")
            }
        }
    }
    
    private var instructionsSection: some View {
        Section(Constants.instructionsSectionLabel) {
            ForEach(viewModel.instructions.indices, id: \.self) { index in
                HStack(alignment: .top) {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.orange))
                        .padding(.top, 2)

                    Divider()
                    
                    TextField(Constants.stepDetailLabel, text: $viewModel.instructions[index], axis: .vertical)
                        .focused($focusedField, equals: .ingredient)
                }
            }
            .onDelete { viewModel.instructions.remove(atOffsets: $0) }
            
            Button {
                withAnimation {
                    viewModel.instructions.append("")
                }
            } label: {
                Label(Constants.addStepLabel, systemImage: "plus.circle.fill")
            }
        }
    }
    
    private var validationFooterSection: some View {
        Section {
            if !viewModel.isFormValid() {
                Text(Constants.validationRequirementFooter)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func saveRecipe() {
        viewModel.save()
        dismiss()
    }
}


// MARK: - Constants

private extension RecipeCreateView {
    enum Constants {
        static let addCoverPhotoLabel = "Add Cover Photo"
        
        static let basicInfoSectionLabel = "Basic Details"
        static let recipeTitleLabel = "Recipe Title"
        static let servingsLabel = "Servings"
        static let descriptionLabel = "Short Description"
        
        static let dietaryInfoSectionLabel = "Dietary Information"
        
        static let ingredientsSectionLabel = "Ingredients"
        static let quantityLabel = "Qty"
        static let ingredientNameLabel = "Ingredient name"
        static let addIngredientButtonLabel = "Add Ingredient"
        
        static let instructionsSectionLabel = "Instructions"
        static let stepDetailLabel = "Step detail"
        static let addStepLabel = "Add Step"
        
        static let validationRequirementFooter = "Please add a title, at least one complete ingredient, and one instruction step."

        static let newRecipeLabel = "New Recipe"
        static let cancelButtonLabel = "Cancel"
        static let saveButtonLabel = "Save"
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
    

    RecipeCreateView(
        recipeRepository: previewRepo,
        authService: previewAuth,
        toastManager: previewToast
    )
}
