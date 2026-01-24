//
//  RecipeFilterCriteria.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/24/26.
//

import Foundation

/// A lightweight struct representing all possible filter states.
struct RecipeFilterCriteria: Equatable {
    var isVegetarian: Bool = false
    var isVegan: Bool = false
    var isGlutenFree: Bool = false
    var isSugarFree: Bool = false
    var minServings: Int = 1
    var includedIngredients: Set<String> = []
    var excludedIngredients: Set<String> = []
    
    // Helper to check if any filter is active (to show a badge)
    var isActive: Bool {
        isVegetarian || isVegan || isGlutenFree || isSugarFree || minServings > 1 || !includedIngredients.isEmpty || !excludedIngredients.isEmpty
    }
}
