//
//  MyRecipesViewModelTests.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/25/26.
//

import XCTest
import Combine

@testable import ReciMeChallenge

@MainActor
final class MyRecipesViewModelTests: XCTestCase {
    var viewModel: MyRecipesViewModel!
    
    var mockRepository: MockRecipeRepository!
    var mockAuthService: MockAuthService!
    var toastManager: ToastManager!
    
    var cancelables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        mockAuthService = MockAuthService()
        toastManager = ToastManager()
        
        viewModel = MyRecipesViewModel(recipeRepository: mockRepository, authService: mockAuthService, toastManager: toastManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockAuthService = nil
        toastManager = nil
        cancelables = []
        super.tearDown()
    }
    
    func testMyRecipes_FiltersByCurrentUser() {
        // Given
        let userId = mockAuthService.currentUserId
        let recipes = (1...3).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil,
                creatorId: $0 == 1 ? userId : "user_\($0)"
            )
        }
        
        let expectation = XCTestExpectation(description: "My recipes updated")
        let cancellable = viewModel.$myRecipes.sink { myRecipes in
            // Then: recipe count will match the number of recipe of the user
            if myRecipes.count == 1 && myRecipes.first?.title == "Recipe 1" {
                expectation.fulfill()
            }
        }
        
        // When: recipes are published to the repo
        mockRepository.addedRecipes = recipes
        wait(for: [expectation], timeout: 1)
        cancellable.cancel()
    }
}
