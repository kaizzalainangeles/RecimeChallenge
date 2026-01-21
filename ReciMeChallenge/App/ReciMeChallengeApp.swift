//
//  ReciMeChallengeApp.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/20/26.
//

import SwiftUI
import CoreData

@main
struct ReciMeChallengeApp: App {
    // 1. Initialize the services (StateObjects keep them alive for the app's lifetime)
    @StateObject private var repository: RecipeRepository

    // We use a 'lazy' approach or initialize in the init to ensure persistence is ready
    init() {
        let persistenceService = RecipePersistenceService()
        let networkService = MockRecipeService()
        
        // Initialize repository with both services
        let repo = RecipeRepository(
            recipeService: networkService,
            persistence: persistenceService
        )
        
        _repository = StateObject(wrappedValue: repo)
    }

    var body: some Scene {
        WindowGroup {
            MainContainerView(repository: repository)
        }
    }
}
