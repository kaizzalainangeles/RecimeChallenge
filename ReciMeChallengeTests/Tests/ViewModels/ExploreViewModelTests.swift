//
//  ExploreViewModelTests.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/25/26.
//

import XCTest

@testable import ReciMeChallenge

@MainActor
final class ExploreViewModelTests: XCTestCase {
    var viewModel: ExploreViewModel!
    var mockRepository: MockRecipeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        viewModel = ExploreViewModel(recipeRepository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testSearchText() {
        // Given
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
                creatorId: "user_\($0)"
            )
        }
        
        mockRepository.addedRecipes = recipes
        viewModel.searchText = "2"
        
        // When
        viewModel.resetAndSearch()
        
        //Then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.title, "Recipe 2")
    }
    
    func testFilter_ByDietaryPreference() {
        // Given
        let vegetarian = DietaryAttributes(isVegetarian: true)
        let nonVegetarian = DietaryAttributes(isVegetarian: false)
        
        let recipes: [Recipe] = [
            Recipe(
                id: "1",
                title: "Recipe 1",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: vegetarian,
                imageUrl: nil
            ),
            Recipe(
                id: "2",
                title: "Recipe 2",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: nonVegetarian,
                imageUrl: nil
            )
        ]
        
        mockRepository.addedRecipes = recipes
        viewModel.criteria.isVegetarian = true
        
        // When
        viewModel.resetAndSearch()
        
        // Then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.title, "Recipe 1")
    }
    
    func testFilter_ByIncludedIngredients() {
        // Given
        let recipes = (1...3).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [Ingredient(name: "ingredient \($0)", quantity: "\($0)")],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil,
                creatorId: "user_\($0)"
            )
        }
        
        mockRepository.addedRecipes = recipes
        viewModel.criteria.includedIngredients = ["ingredient 2"]
        
        // When
        viewModel.resetAndSearch()
        
        // then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.title, "Recipe 2")
    }
    
    func testFilter_ByExcludedIngredients() {
        // Given
        let recipes = (1...2).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [Ingredient(name: "ingredient \($0)", quantity: "\($0)")],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil,
                creatorId: "user_\($0)"
            )
        }
        
        mockRepository.addedRecipes = recipes
        viewModel.criteria.excludedIngredients = ["ingredient 2"]
        
        // When
        viewModel.resetAndSearch()
        
        // Then
        XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        XCTAssertEqual(viewModel.filteredRecipes.first?.title, "Recipe 1")
    }
    
    func testPagination_loadsNextPage() async {
        // Given
        let recipes = (1...20).map {
            Recipe(
                id: "\($0)",
                title: "Recipe \($0)",
                description: "",
                servings: 2,
                ingredients: [],
                instructions: [],
                dietaryAttributes: DietaryAttributes(),
                imageUrl: nil
            )
        }
        
        mockRepository.addedRecipes = recipes
        viewModel.searchText = "Recipe"
        
        // Then: Count will be 10 before triggering the pagination
        XCTAssertEqual(viewModel.filteredRecipes.count, 10)
        
        // When
        await MainActor.run {
            viewModel.loadNextPage()
        }
        
        try? await Task.sleep(nanoseconds: 900_000_000)
        
        // Then: Count will be more than 10 after triggering the pagination
        XCTAssertTrue(viewModel.filteredRecipes.count > 10)
    }
}
