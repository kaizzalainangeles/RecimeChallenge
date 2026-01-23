//
//  RecipeRepository.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine

protocol RecipeRepositoryProtocol {
    var recipesPublisher: AnyPublisher<[Recipe], Never> { get }
    func sync() async
    func addRecipe(_ recipe: Recipe) async
    func deleteRecipe(_ recipe: Recipe)
}

@MainActor
class RecipeRepository: ObservableObject, RecipeRepositoryProtocol {
    @Published private(set) var recipes: [Recipe] = []
    
    var recipesPublisher: AnyPublisher<[Recipe], Never> {
        $recipes.eraseToAnyPublisher()
    }
    
    private let recipeService: RecipeService
    private let persistence: RecipePersistenceService
    
    init(recipeService: RecipeService, persistence: RecipePersistenceService) {
        self.recipeService = recipeService
        self.persistence = persistence

        self.recipes = persistence.fetchRecipes()
    }
    
    func sync() async {
        do {
            let remote = try await recipeService.fetchRecipes()
            persistence.saveRecipes(remote)

            self.recipes = persistence.fetchRecipes()
        } catch {
            print("Sync failed, using offline data")
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        persistence.saveRecipes([recipe])
        
        // Refresh the local published list
        self.recipes = persistence.fetchRecipes()
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        persistence.deleteRecipe(id: recipe.id)
        deleteRecipeImageFromDiskIfNeeded(recipe)
        
        // Refresh the local published list
        self.recipes = persistence.fetchRecipes()
    }
    
    func saveImageToDisk(data: Data) -> URL? {
        let fileName = "\(UUID().uuidString).jpg"
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folder.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return URL(string: fileName)
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func deleteRecipeImageFromDiskIfNeeded(_ recipe: Recipe) {
        // Remove the image file from disk if it's local
        if let url = recipe.resolvedImageURL, url.isFileURL {
            let fileName = url.lastPathComponent
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
