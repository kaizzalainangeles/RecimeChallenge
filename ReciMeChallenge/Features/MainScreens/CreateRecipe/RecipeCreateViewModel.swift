//
//  RecipeCreateViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI
import Combine
import PhotosUI

enum DietaryFilter: String, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten Free"
    case sugarFree = "Sugar Free"
}

@MainActor
class RecipeCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var servings: Int = 1
    @Published var ingredients: [Ingredient] = [Ingredient(name: "", quantity: "")]
    @Published var instructions: [String] = [""]
    @Published var selectedDietary: Set<DietaryFilter> = []
    @Published var selectedImageData: Data? = nil

    private let recipeRepository: RecipeRepositoryProtocol
    private let authService: AuthServiceProtocol
    private let toastManager: ToastManager

    init(recipeRepository: RecipeRepositoryProtocol, authService: AuthServiceProtocol, toastManager: ToastManager) {
        self.recipeRepository = recipeRepository
        self.authService = authService
        self.toastManager = toastManager
    }
    
    func save() {
        var finalImageURL: URL? = nil
        
        if let data = selectedImageData {
            finalImageURL = recipeRepository.saveImageToDisk(data: data)
        }
        
        cleanInputStrings()
        
        let dietary = DietaryAttributes(
            isVegetarian: selectedDietary.contains(.vegetarian),
            isVegan: selectedDietary.contains(.vegan),
            isGlutenFree: selectedDietary.contains(.glutenFree),
            isSugarFree: selectedDietary.contains(.sugarFree)
        )
        
        let newRecipe = Recipe(
            title: title,
            description: description,
            servings: servings,
            ingredients: ingredients.filter { !$0.name.isEmpty },
            instructions: instructions.filter { !$0.isEmpty },
            dietaryAttributes: dietary,
            imageURL: finalImageURL,
            creatorId: authService.currentUserId
        )
        
        recipeRepository.addRecipe(newRecipe)
        toastManager.show(style: .success, message: "Recipe added successfully!")
    }
    
    func cleanInputStrings() {
        // 1. Trim whitespace and newlines from the title
        self.title = self.title.trimmingCharacters(in: .whitespacesAndNewlines)
            
        // 2. Clean Ingredients: Remove empty rows and trim text
        self.ingredients = self.ingredients.compactMap { ingredient in
            let cleanedName = ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanedName.isEmpty { return nil } // Remove the row if name is empty
            
            return Ingredient(
                name: cleanedName,
                quantity: ingredient.quantity.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }
        
        // 3. Clean Instructions: Remove empty steps and trim whitespace
        self.instructions = self.instructions.compactMap { step in
            let cleanedStep = step.trimmingCharacters(in: .whitespacesAndNewlines)
            return cleanedStep.isEmpty ? nil : cleanedStep
        }
    }
    
    func handleImageSelection(_ item: PhotosPickerItem?) {
        Task { @MainActor in
            guard let item = item else { return }
            if let data = try? await item.loadTransferable(type: Data.self) {
                self.selectedImageData = data
            }
        }
    }
    
    func isFormValid() -> Bool {
        let hasTitle = !title.trimmingCharacters(in: .whitespaces).isEmpty
        
        // Ensure at least one ingredient exists and has a name/quantity
        let hasIngredients = !ingredients.isEmpty && ingredients.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespaces).isEmpty &&
            !$0.quantity.trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        // Ensure at least one instruction exists and isn't empty
        let hasInstructions = !instructions.isEmpty && instructions.allSatisfy {
            !$0.trimmingCharacters(in: .whitespaces).isEmpty
        }

        return hasTitle && hasIngredients && hasInstructions
    }
}
