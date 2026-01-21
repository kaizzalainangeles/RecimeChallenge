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
        
        // Refresh the local published list
        self.recipes = persistence.fetchRecipes()
    }
}
