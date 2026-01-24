//
//  DashboardViewModelTests.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/25/26.
//

import XCTest

@testable import ReciMeChallenge

@MainActor
final class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    
    var mockRepository: MockRecipeRepository!
    var mockAuthService: MockAuthService!
    var toastManager: ToastManager!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        mockAuthService = MockAuthService()
        toastManager = ToastManager()
        
        viewModel = DashboardViewModel(recipeRepository: mockRepository, authService: mockAuthService, toastManager: toastManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockAuthService = nil
        toastManager = nil
        super.tearDown()
    }
    
    func testSelectedRandomFeatured() {
        // Given
        let recipes = (1...10).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil,
                creatorId: "user_1"
            )
        }
        
        viewModel.allRecipes = recipes
        
        // When
        viewModel.selectRandomFeatured()
        
        // Then
        XCTAssertEqual(viewModel.featuredRecipes.count, 5)
        XCTAssertTrue(viewModel.allRecipes.contains(viewModel.featuredRecipes.first!))
    }
    
    func testSelectedOwnedRecipes() {
        // Given
        mockAuthService.currentUserId = "user_1"
        
        let recipes = (1...10).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil,
                creatorId: "user_\($0)"
            )
        }
        
        viewModel.allRecipes = recipes
        
        // When
        viewModel.selectOwnedRecipes()
        
        // Then
        XCTAssertEqual(viewModel.ownedRecipes.count, 1)
        XCTAssertTrue(viewModel.ownedRecipes.allSatisfy { $0.creatorId == "user_1" })
    }
}
