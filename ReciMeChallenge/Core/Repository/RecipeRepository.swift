//
//  RecipeRepository.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import Combine

/// Protocol to define the contract for recipe data access
///
/// Implementations of this protocol are responsible for providing access to recipe data,
/// whether from a local database, remote API, or other sources.
protocol RecipeRepositoryProtocol {
    var recipesPublisher: AnyPublisher<[Recipe], Never> { get }
    func sync() async throws
    func addRecipe(_ recipe: Recipe) throws
    func deleteRecipe(_ recipe: Recipe) throws
    func saveImageToDisk(data: Data) throws -> URL?
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
    
    func sync() async throws {
        let remote = try await recipeService.fetchRecipes()
        try persistence.saveRecipes(remote)
        
        self.recipes = persistence.fetchRecipes()
    }
    
    func addRecipe(_ recipe: Recipe) throws {
        try persistence.saveRecipes([recipe])
        
        // Refresh the local published list
        self.recipes = persistence.fetchRecipes()
    }
    
    func deleteRecipe(_ recipe: Recipe) throws {
        try persistence.deleteRecipe(id: recipe.id)
        deleteRecipeImageFromDiskIfNeeded(recipe)
        
        // Refresh the local published list
        self.recipes = persistence.fetchRecipes()
    }
}


// MARK: - Image Helpers

extension RecipeRepository {
    func saveImageToDisk(data: Data) throws -> URL? {
        let fileName = "\(UUID().uuidString).jpg"
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = folder.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return URL(string: fileName)
        } catch {
            throw RecipeError.imageSaveFailed
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
