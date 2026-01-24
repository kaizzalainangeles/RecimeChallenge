//
//  RecipeRepositoryTests.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/24/26.
//

import XCTest

@testable import ReciMeChallenge

@MainActor
final class RecipeRepositoryTests: XCTestCase {
    var repository: RecipeRepository!
    var mockService: MockRecipeService!
    var mockPersistence: MockPersistence!

    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        mockPersistence = MockPersistence()
        repository = RecipeRepository(recipeService: mockService, persistence: mockPersistence)
    }

    func testSyncSuccess_UpdatesLocalRecipes() async throws {
        // Given
        let remoteRecipe = Recipe(
            id: "101",
            title: "Healthy Salad",
            description: "A fresh and vibrant salad.",
            servings: 2,
            ingredients: [],
            instructions: [],
            dietaryAttributes: DietaryAttributes(),
            imageUrl: nil
        )
        
        mockService.mockRecipes = [remoteRecipe]

        // When
        try await repository.sync()

        // Then
        XCTAssertEqual(repository.recipes.count, 1)
        XCTAssertEqual(repository.recipes.first?.id, "101")
    }

    func testDeleteRecipe_RemovesFromPersistence() throws {
        let recipe = Recipe(
            id: "101",
            title: "Healthy Salad",
            description: "A fresh and vibrant salad.",
            servings: 2,
            ingredients: [],
            instructions: [],
            dietaryAttributes: DietaryAttributes(),
            imageUrl: nil
        )
        
        mockPersistence.storedRecipes = [recipe]
        
        // When
        try repository.deleteRecipe(recipe)
        
        // Then
        XCTAssertTrue(mockPersistence.storedRecipes.isEmpty)
    }
}
