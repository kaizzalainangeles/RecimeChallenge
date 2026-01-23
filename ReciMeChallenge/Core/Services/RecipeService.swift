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

final class FetchRecipeService: RecipeService {
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            // This allows the decoder to match "imageURL" in Swift to "imageURL" or "image_url" in JSON
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            print("Decoding Error: \(error)") // Logging error to determine exactly which field failed
            throw error
        }
    }
}
