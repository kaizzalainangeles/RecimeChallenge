//
//  RecipeService.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

protocol RecipeService {
    func fetchRecipes() async throws -> [Recipe]
}

