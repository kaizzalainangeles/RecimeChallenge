//
//  RecipeCreateViewModelTests.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/25/26.
//

import XCTest

@testable import ReciMeChallenge

@MainActor
final class RecipeCreateViewModelTests: XCTestCase {
    var viewModel: RecipeCreateViewModel!
    
    var mockRepository: MockRecipeRepository!
    var mockAuthService: MockAuthService!
    var toastManager: ToastManager!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRecipeRepository()
        mockAuthService = MockAuthService()
        toastManager = ToastManager()
        
        viewModel = RecipeCreateViewModel(recipeRepository: mockRepository, authService: mockAuthService, toastManager: toastManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockAuthService = nil
        toastManager = nil
        super.tearDown()
    }
    
    // MARK: - Form Validation Tests
    
    func testIsFormValid_WithAllRequiredFields_ReturnsTrue() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = [Ingredient(name: "Test Ingredient", quantity: "1 cup")]
        viewModel.instructions = ["Test instruction"]
        
        // When & Then
        XCTAssertTrue(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithMissingTitle_ReturnsFalse() {
        // Given
        viewModel.title = ""
        viewModel.ingredients = [Ingredient(name: "Test Ingredient", quantity: "1 cup")]
        viewModel.instructions = ["Test instruction"]
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithEmptyIngredients_ReturnsFalse() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = []
        viewModel.instructions = ["Test instruction"]
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithIngredientsMissingName_ReturnsFalse() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = [Ingredient(name: "", quantity: "1 cup")]
        viewModel.instructions = ["Test instruction"]
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithIngredientsMissingQuantity_ReturnsFalse() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = [Ingredient(name: "Test Ingredient", quantity: "")]
        viewModel.instructions = ["Test instruction"]
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithEmptyInstructions_ReturnsFalse() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = [Ingredient(name: "Test Ingredient", quantity: "1 cup")]
        viewModel.instructions = []
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    func testIsFormValid_WithBlankInstructions_ReturnsFalse() {
        // Given
        viewModel.title = "Test Recipe"
        viewModel.ingredients = [Ingredient(name: "Test Ingredient", quantity: "1 cup")]
        viewModel.instructions = [""]
        
        // When & Then
        XCTAssertFalse(viewModel.isFormValid())
    }
    
    // MARK: - Clean Input Strings Tests
    
    func testCleanInputStrings_TrimsWhitespaceFromTitle() {
        // Given
        viewModel.title = "  Recipe Title with Spaces  "
        
        // When
        viewModel.cleanInputStrings()
        
        // Then
        XCTAssertEqual(viewModel.title, "Recipe Title with Spaces")
    }
    
    func testCleanInputStrings_TrimsIngredients() {
        // Given
        viewModel.ingredients = [
            Ingredient(name: "  Flour  ", quantity: "  1 cup  "),
            Ingredient(name: "  Sugar  ", quantity: "  2 tbsp  ")
        ]
        
        // When
        viewModel.cleanInputStrings()
        
        // Then
        XCTAssertEqual(viewModel.ingredients.count, 2)
        XCTAssertEqual(viewModel.ingredients[0].name, "Flour")
        XCTAssertEqual(viewModel.ingredients[0].quantity, "1 cup")
        XCTAssertEqual(viewModel.ingredients[1].name, "Sugar")
        XCTAssertEqual(viewModel.ingredients[1].quantity, "2 tbsp")
    }
    
    func testCleanInputStrings_RemovesEmptyIngredients() {
        // Given
        viewModel.ingredients = [
            Ingredient(name: "Flour", quantity: "1 cup"),
            Ingredient(name: "", quantity: "2 tbsp"),
            Ingredient(name: "  ", quantity: "3 oz")
        ]
        
        // When
        viewModel.cleanInputStrings()
        
        // Then
        XCTAssertEqual(viewModel.ingredients.count, 1)
        XCTAssertEqual(viewModel.ingredients[0].name, "Flour")
    }
    
    func testCleanInputStrings_TrimsInstructions() {
        // Given
        viewModel.instructions = [
            "  First instruction  ",
            "  Second instruction  "
        ]
        
        // When
        viewModel.cleanInputStrings()
        
        // Then
        XCTAssertEqual(viewModel.instructions.count, 2)
        XCTAssertEqual(viewModel.instructions[0], "First instruction")
        XCTAssertEqual(viewModel.instructions[1], "Second instruction")
    }
    
    func testCleanInputStrings_RemovesEmptyInstructions() {
        // Given
        viewModel.instructions = [
            "First instruction",
            "",
            "  "
        ]
        
        // When
        viewModel.cleanInputStrings()
        
        // Then
        XCTAssertEqual(viewModel.instructions.count, 1)
        XCTAssertEqual(viewModel.instructions[0], "First instruction")
    }
    
    // MARK: - Save Image Tests
    
    func testSaveSelectedImageToDisk_WithNilData_ReturnsNil() {
        // Given
        viewModel.selectedImageData = nil
        
        // When
        let result = viewModel.saveSelectedImageToDisk()
        
        // Then
        XCTAssertNil(result)
    }
    
    func testSaveSelectedImageToDisk_WithValidData_CallsRepository() {
        // Given
        let testData = Data([0, 1, 2, 3])
        let testURL = URL(string: "test.jpg")!
        viewModel.selectedImageData = testData
        mockRepository.mockImageURL = testURL
        
        // When
        let result = viewModel.saveSelectedImageToDisk()
        
        // Then
        XCTAssertEqual(result, testURL)
        XCTAssertEqual(mockRepository.savedImageData, testData)
    }
    
    // MARK: - Save Recipe Tests
    
    func testSave_CreatesRecipeWithCorrectData() throws {
        // Given
        viewModel.title = "Pancakes"
        viewModel.description = "Fluffy breakfast pancakes"
        viewModel.servings = 4
        viewModel.ingredients = [
            Ingredient(name: "Flour", quantity: "2 cups"),
            Ingredient(name: "Milk", quantity: "1 cup")
        ]
        viewModel.instructions = ["Mix ingredients", "Cook on griddle"]
        viewModel.selectedDietary = [.glutenFree, .vegan]
        
        // Mock image data
        let testImageData = Data([1, 2, 3, 4])
        let testImageURL = URL(string: "test-image.jpg")!
        viewModel.selectedImageData = testImageData
        mockRepository.mockImageURL = testImageURL
        
        // When
        viewModel.save()
        
        // Then
        XCTAssertEqual(mockRepository.addedRecipes.count, 1)
        let savedRecipe = try XCTUnwrap(mockRepository.addedRecipes.first)
        
        XCTAssertEqual(savedRecipe.title, "Pancakes")
        XCTAssertEqual(savedRecipe.description, "Fluffy breakfast pancakes")
        XCTAssertEqual(savedRecipe.servings, 4)
        XCTAssertEqual(savedRecipe.ingredients.count, 2)
        XCTAssertEqual(savedRecipe.ingredients[0].name, "Flour")
        XCTAssertEqual(savedRecipe.ingredients[1].quantity, "1 cup")
        XCTAssertEqual(savedRecipe.instructions.count, 2)
        XCTAssertEqual(savedRecipe.instructions[0], "Mix ingredients")
        XCTAssertEqual(savedRecipe.dietaryAttributes.isGlutenFree, true)
        XCTAssertEqual(savedRecipe.dietaryAttributes.isVegan, true)
        XCTAssertEqual(savedRecipe.dietaryAttributes.isVegetarian, false)
        XCTAssertEqual(savedRecipe.dietaryAttributes.isSugarFree, false)
        XCTAssertEqual(savedRecipe.imageUrl, testImageURL)
        XCTAssertEqual(savedRecipe.creatorId, mockAuthService.currentUserId)
    }
}
