//
//  RecipeCoreDataStorage.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import CoreData

final class RecipeCoreDataStorage {
    static let shared = RecipeCoreDataStorage()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ReciMeChallenge")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
