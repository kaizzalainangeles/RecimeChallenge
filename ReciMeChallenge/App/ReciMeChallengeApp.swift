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
    // Initialize the services (StateObjects keep them alive for the app's lifetime)
    @StateObject private var repository: RecipeRepository
    @StateObject private var authService = AuthService()
    
    init() {
        let persistenceService = RecipeCoreDataStorage()
        let networkService = FetchRecipeService()
        
        // Initialize repository with both services
        let repo = RecipeRepository(
            recipeService: networkService,
            persistence: persistenceService
        )
        
        _repository = StateObject(wrappedValue: repo)
    }

    var body: some Scene {
        WindowGroup {
            MainContainerView(repository: repository, authService: authService)
        }
    }
}
