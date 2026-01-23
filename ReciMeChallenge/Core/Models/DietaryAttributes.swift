//
//  DietaryAttributes.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import SwiftUI

struct DietaryAttributes: Codable, Hashable {
    let isVegetarian: Bool?
    let isVegan: Bool?
    let isGlutenFree: Bool?
    let isSugarFree: Bool?

    // Custom init for decoding to provide false as default
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isVegetarian = try container.decodeIfPresent(Bool.self, forKey: .isVegetarian) ?? false
        isVegan = try container.decodeIfPresent(Bool.self, forKey: .isVegan) ?? false
        isGlutenFree = try container.decodeIfPresent(Bool.self, forKey: .isGlutenFree) ?? false
        isSugarFree = try container.decodeIfPresent(Bool.self, forKey: .isSugarFree) ?? false
    }

    // Default init for when the whole object is missing
    init(isVegetarian: Bool? = nil, isVegan: Bool? = nil, isGlutenFree: Bool? = nil, isSugarFree: Bool? = nil) {
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.isGlutenFree = isGlutenFree
        self.isSugarFree = isSugarFree
    }
}

extension DietaryAttributes {
    struct DietTag: Identifiable {
        let id = UUID()
        let label: String
        let icon: String
        let color: Color
    }

    var activeTags: [DietTag] {
        var tags = [DietTag]()
        if isVegetarian == true { tags.append(DietTag(label: "Vegetarian", icon: "leaf.fill", color: .green)) }
        if isVegan == true { tags.append(DietTag(label: "Vegan", icon: "carrot.fill", color: .green)) }
        if isGlutenFree == true { tags.append(DietTag(label: "Gluten-Free", icon: "wheat", color: .orange)) }
        if isSugarFree == true { tags.append(DietTag(label: "Sugar-Free", icon: "bubbles.and.sparkles.fill", color: .blue)) }
        return tags
    }
}
