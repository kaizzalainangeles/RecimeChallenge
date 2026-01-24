//
//  MockServices.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/24/26.
//

import XCTest

@testable import ReciMeChallenge

class MockRecipeService: RecipeService {
    var mockRecipes: [Recipe] = []
    var shouldFail = false
    
    func fetchRecipes() async throws -> [Recipe] {
        if shouldFail { throw URLError(.badServerResponse) }
        return mockRecipes
    }
}

class MockPersistence: RecipePersistenceService {
    var storedRecipes: [Recipe] = []
    
    func fetchRecipes() -> [Recipe] { storedRecipes }
    func saveRecipes(_ recipes: [Recipe]) throws { storedRecipes.append(contentsOf: recipes) }
    func deleteRecipe(id: String) throws { storedRecipes.removeAll { $0.id == id } }
}

class MockAuthService: AuthServiceProtocol {
    var currentUserId: String = "user_17"
    var currentUser: User = User(
        id: "user_17",
        userName: "test_user",
        email: "test@test.com",
        userBio: "This is a test",
        followers: 7,
        likes: 7
    )
}
