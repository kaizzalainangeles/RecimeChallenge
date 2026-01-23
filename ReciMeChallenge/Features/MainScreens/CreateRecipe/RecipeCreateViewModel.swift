//
//  RecipeCreateViewModel.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI
import Combine
@MainActor
class RecipeCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var servings: Int = 1
    @Published var ingredients: [Ingredient] = [Ingredient(name: "", quantity: "")]
    @Published var instructions: [String] = [""]
    @Published var selectedDietary: Set<DietaryFilter> = []
    @Published var selectedImageData: Data? = nil

    private let recipeRepository: RecipeRepository
    private let authService: AuthService = .shared
    
    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }
    
    func save() {
        var finalImageURL: URL? = nil
        
        if let data = selectedImageData {
            finalImageURL = saveImageToDisk(data: data)
        }
        
        let dietary = DietaryAttributes(
            isVegetarian: selectedDietary.contains(.vegetarian),
            isVegan: selectedDietary.contains(.vegan),
            isGlutenFree: selectedDietary.contains(.glutenFree)
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
    }
    
    private func saveImageToDisk(data: Data) -> URL? {
        let fileName = "\(UUID().uuidString).jpg"
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folder.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}
