//
//  RecipeCoreDataService.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import Foundation
import CoreData

protocol RecipePersistenceService{
    func saveRecipes(_ recipes: [Recipe]) throws
    func fetchRecipes() -> [Recipe]
    func deleteRecipe(id: String) throws
}

final class RecipeCoreDataStorage: RecipePersistenceService {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ReciMeChallenge")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveRecipes(_ recipes: [Recipe]) throws {
        for recipe in recipes {
            // 1. Check for existing entity to prevent duplicates (Upsert)
            let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", recipe.id)
            
            let entity: RecipeEntity
            if let existing = try? context.fetch(request).first {
                entity = existing
            } else {
                entity = RecipeEntity(context: context)
                entity.id = recipe.id
            }
            
            // 2. Map properties
            entity.title = recipe.title
            entity.desc = recipe.description
            entity.imageURL = recipe.imageURL
            entity.servings = Int16(recipe.servings)
            entity.creatorId = recipe.creatorId
            
            // 3. Encode complex types
            do {
                let encoder = JSONEncoder()
                entity.ingredients = try encoder.encode(recipe.ingredients)
                entity.instructions = try encoder.encode(recipe.instructions)
                entity.dietaryAttributes = try encoder.encode(recipe.dietaryAttributes)
            } catch {
                throw RecipeError.persistenceFailure(error.localizedDescription)
            }
        }
        
        // 4. Perform the save
        try save()
    }
    
    func fetchRecipes() -> [Recipe] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        // Sort descriptor to keep order consistent
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let entities = (try? context.fetch(request)) ?? []
        let decoder = JSONDecoder()
        
        return entities.compactMap { entity in
            // Guard only for the absolutely vital field: ID
            guard let id = entity.id else { return nil }
            
            // Use our strategy: decode or provide defaults if the Blob is missing
            let ingredients = (try? decoder.decode([Ingredient].self, from: entity.ingredients ?? Data())) ?? []
            let instructions = (try? decoder.decode([String].self, from: entity.instructions ?? Data())) ?? []
            let dietary = (try? decoder.decode(DietaryAttributes.self, from: entity.dietaryAttributes ?? Data())) ?? DietaryAttributes()
            
            return Recipe(
                id: id,
                title: entity.title ?? "Untitled",
                description: entity.desc ?? "",
                servings: Int(entity.servings),
                ingredients: ingredients,
                instructions: instructions,
                dietaryAttributes: dietary,
                imageURL: entity.imageURL,
                creatorId: entity.creatorId ?? nil
            )
        }
    }
    
    func deleteRecipe(id: String) throws {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        if let entityToDelete = try? context.fetch(request).first {
            context.delete(entityToDelete)
            
            try save()
        }
    }
}
