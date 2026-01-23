//
//  Ingredient.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation

/// Represents the instructions for a recipe.
struct Ingredient: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var quantity: String
    
    init(id: String = UUID().uuidString, name: String, quantity: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
    }
}

