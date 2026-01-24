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
            
            // 3. Configure the JSON decoder.
            let decoder = JSONDecoder()
            
            // Note: This allows the decoder to match "imageUrl" in Swift to "imageUrl" or "image_url" in JSON
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // 4. Decode the data into an array of Recipe objects.
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            throw RecipeError.decodingError(error.localizedDescription)
        }
    }
}
