//
//  Tab.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import Foundation

/// Defines the main navigation sections of the ReciMe app.
enum Tab: Int, CaseIterable {
    case home = 0
    case search = 1
    case recipes = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .recipes: return "My Recipes"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .recipes: return "fork.knife"
        case .profile: return "person.fill"
        }
    }
}
