//
//  RecipeService.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation

protocol RecipeService {
    func fetchRecipes() async throws -> [Recipe]
}

/// A service that simulates an API call by loading data from a local JSON file.
final class FetchRecipeService: RecipeService {
    func fetchRecipes() async throws -> [Recipe] {
        // 1. Locate the 'recipes.json' file within the app's main bundle.
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        do {
            // 2. Load the raw data from the file.
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            // Note: This allows the decoder to match "imageUrl" in Swift to "imageUrl" or "image_url" in JSON
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // 4. Decode the data into an array of Recipe objects (return nil if a mandatory field is missing)
            let recipes = try decoder.decode([Safe<Recipe>].self, from: data)
            return recipes.compactMap { $0.value }
        } catch {
            throw RecipeError.decodingError(error.localizedDescription)
        }
    }
}

private struct Safe<T: Decodable>: Decodable {
    let value: T?

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(T.self)
        } catch {
            self.value = nil
        }
    }
}
