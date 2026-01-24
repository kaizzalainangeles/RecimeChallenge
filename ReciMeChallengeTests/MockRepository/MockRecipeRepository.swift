//
//  MockRecipeRepository.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/25/26.
//

import XCTest
import Combine

@testable import ReciMeChallenge

@MainActor
class MockRecipeRepository: RecipeRepositoryProtocol {
    var recipesPublisher: AnyPublisher<[Recipe], Never> {
        $addedRecipes.eraseToAnyPublisher()
    }
    
    @Published var addedRecipes: [Recipe] = []
    var shouldThrowErrorOnAddRecipe: Bool = false
    var shouldThrowErrorOnImageSave: Bool = false
    var mockImageURL: URL? = nil
    var savedImageData: Data? = nil
    
    func sync() async throws {
        
    }
    
    func addRecipe(_ recipe: ReciMeChallenge.Recipe) throws {
        if shouldThrowErrorOnAddRecipe {
            throw RecipeError.persistenceFailure("Can't save recipe")
        }
        
        addedRecipes.append(recipe)
    }
    
    func deleteRecipe(_ recipe: ReciMeChallenge.Recipe) throws {
        
    }
    
    func saveImageToDisk(data: Data) throws -> URL? {
        if shouldThrowErrorOnImageSave {
            throw RecipeError.imageSaveFailed
        }
        
        savedImageData = data
        return mockImageURL
    }
}
