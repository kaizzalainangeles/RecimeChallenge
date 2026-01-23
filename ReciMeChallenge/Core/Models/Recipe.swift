//
//  Recipe.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation

/// A model representing a cooking recipe
///
/// Recipe objects contain all the information needed to display and manage cooking recipes,
/// including ingredients, instructions, and dietary information.
///
/// Recipe objects are both `Identifiable` (for SwiftUI lists) and `Codable` (for JSON parsing).
struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let servings: Int
    let ingredients: [Ingredient]
    let instructions: [String]
    let dietaryAttributes: DietaryAttributes
    let imageURL: URL?
    let creatorId: String?

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        servings: Int,
        ingredients: [Ingredient],
        instructions: [String],
        dietaryAttributes: DietaryAttributes,
        imageURL: URL?,
        creatorId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.servings = servings
        self.ingredients = ingredients
        self.instructions = instructions
        self.dietaryAttributes = dietaryAttributes
        self.imageURL = imageURL
        self.creatorId = creatorId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        // Fields with default values if missing or null
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        servings = try container.decodeIfPresent(Int.self, forKey: .servings) ?? 1
        ingredients = try container.decodeIfPresent([Ingredient].self, forKey: .ingredients) ?? []
        instructions = try container.decodeIfPresent([String].self, forKey: .instructions) ?? []
        
        // Handle nested object with defaults
        dietaryAttributes = try container.decodeIfPresent(DietaryAttributes.self, forKey: .dietaryAttributes) ?? DietaryAttributes()
        
        // Truly optional field
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        creatorId = try container.decodeIfPresent(String.self, forKey: .creatorId)
    }
    
    var resolvedImageURL: URL? {
        guard let originalURL = imageURL else { return nil }
        
        if originalURL.scheme == "http" || originalURL.scheme == "https" {
            return originalURL
        }
        
        // If it's a local file URL, we need to rebuild it because the
        // Application UUID in the path changes on every build/install.
        let fileName = originalURL.lastPathComponent
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
