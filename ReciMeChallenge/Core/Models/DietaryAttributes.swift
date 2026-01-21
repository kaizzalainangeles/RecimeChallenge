//
//  DietaryAttributes.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation

struct DietaryAttributes: Codable, Hashable {
    let isVegetarian: Bool?
    let isVegan: Bool?
    let isGlutenFree: Bool?

    // Custom init for decoding to provide false as default
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isVegetarian = try container.decodeIfPresent(Bool.self, forKey: .isVegetarian) ?? false
        isVegan = try container.decodeIfPresent(Bool.self, forKey: .isVegan) ?? false
        isGlutenFree = try container.decodeIfPresent(Bool.self, forKey: .isGlutenFree) ?? false
    }

    // Default init for when the whole object is missing
    init(isVegetarian: Bool? = nil, isVegan: Bool? = nil, isGlutenFree: Bool? = nil) {
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.isGlutenFree = isGlutenFree
    }
}

