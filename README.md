# ReciMe Challenge

A modern iOS recipe browsing and creation application built with Swift and SwiftUI.

![ReciMe App](ReciMeChallenge/Assets.xcassets/SplashLogo.imageset/Logo.png)

## Overview

ReciMeChallenge is a feature-rich iOS application that allows users to browse, search, and create cooking recipes. The app provides an intuitive interface for viewing recipe details including title, description, servings, ingredients, cooking instructions, and dietary attributes. Initially built to meet basic requirements of browsing mock recipe data, the app has been enhanced with additional features like recipe creation, image support, persistent storage, and more.

## Features

- **Recipe Browsing**: Browse through a collection of recipes with a clean, intuitive interface
- **Recipe Details**: View comprehensive recipe information including ingredients, instructions, and dietary attributes
- **Search & Filtering**: Find recipes easily with search and dietary filter capabilities
- **Recipe Creation**: Create and save your own recipes with custom images
- **Data Persistence Support**: Core Data integration for data persistence
- **Modern UI**: Built with SwiftUI for a responsive and modern user experience
- **Concurrency**: Utilizes Swift concurrency features for efficient data handling

## Setup Instructions

### Requirements

- Xcode 26.0+
- iOS 26.2
- Swift 5.7+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kaizzalainangeles/RecimeChallenge.git
   ```

2. Open the project in Xcode:
   ```bash
   cd RecimeChallenge
   open ReciMeChallenge.xcodeproj
   ```

3. Select a simulator or connected device.

4. Build and run the project (⌘+R).

## High-Level Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern with a repository layer for data management:

### Core Layers

1. **Models**: Define the data structures (Recipe, Ingredient, DietaryAttributes)
2. **Views**: SwiftUI views responsible for UI rendering
3. **ViewModels**: Handle business logic and prepare data for views
4. **Repository**: Coordinates between data sources (local storage and network)
5. **Services**: Handle specific functionality like data fetching
6. **Storage**: Manages Core Data operations for data persistence

### Data Flow

1. **UI Layer**: User interacts with SwiftUI views
2. **ViewModels**: Process user actions and update UI state
3. **Repository**: Coordinates data operations between services and storage
4. **Services**: Fetch data from the network or provide mock data
5. **Storage**: Persists data using Core Data

## Directory Structure

```
ReciMeChallenge/
├── App/                   # App entry point and configuration
├── Assets/                # Images and resources
├── Core/                  # Core business logic
│   ├── Models/            # Data models
│   ├── Repository/        # Data coordination layer
│   ├── Services/          # Business services (API, mock)
│   └── Storage/           # Core Data services
├── Features/              # UI features organized by domain
│   └── Recipes/           # Recipe-related features
│       ├── CreateRecipe/  # Recipe creation
│       ├── Dashboard/     # Main dashboard
│       ├── Explore/       # Search and explore
│       ├── MainContainer/ # Tab container
│       ├── MyRecipes/     # User's recipes
│       └── RecipeDetail/  # Recipe details
└── Resources/             # External resources (JSON)
```

## Key Design Decisions

### 1. Repository Pattern

The app uses a repository pattern to abstract data sources, making it easy to switch between mock data and real API data. The repository coordinates between:
- Network services for fetching remote data (via JSON file)
- Core Data for local persistence

This provides a single source of truth for recipe data throughout the app.

### 2. MVVM Architecture

Each feature follows the MVVM pattern:
- **Models**: Plain Swift structs conforming to `Codable`
- **Views**: SwiftUI views for UI representation
- **ViewModels**: Observable classes managing UI state and business logic

This separation of concerns improves testability and maintainability.

### 3. Protocol-Oriented Design

Services are defined using protocols, allowing for easy mocking and testing:
```swift
protocol RecipeService {
    func fetchRecipes() async throws -> [Recipe]
}
```

### 4. Core Data Integration

Core Data is used for offline persistence, with a service layer that abstracts the complexities of Core Data operations:
- RecipePersistenceService: Handles Core Data setup and operations
- JSON encoding/decoding for complex types within Core Data

### 5. Combine Framework

The app leverages Combine for reactive data flow, particularly in the repository layer:
```swift
var recipesPublisher: AnyPublisher<[Recipe], Never> {
    $recipes.eraseToAnyPublisher()
}
```

### 6. Swift Concurrency

Modern Swift concurrency features (async/await) are used for asynchronous operations:
```swift
func sync() async {
    do {
        let remote = try await recipeService.fetchRecipes()
        persistence.saveRecipes(remote)

        self.recipes = persistence.fetchRecipes()
    } catch {
        print("Sync failed, using offline data")
    }
}
```

### 7. Models Implementation (e.g. Dietary Attribute)

The current implementation of `DietaryAttributes` model represents a trade-off between simplicity and extensibility. The static approach provides clear, type-safe code that's easy to work with but limited adaptability. For a prototype or MVP application with a fixed requirements, I find this approach reasonable.

```swift
struct DietaryAttributes: Codable, Hashable {
    let isVegetarian: Bool?
    let isVegan: Bool?
    let isGlutenFree: Bool?
    let isSugarFree: Bool?

```

## Assumptions and Tradeoffs

### Assumptions

1. **User Experience**: The app assumes users prefer a visual, image-centric experience when browsing recipes.

2. **Data Volume**: The current implementation assumes a moderate number of recipes. With very large datasets, additional pagination or virtual rendering would be needed.

3. **Offline-First**: The app prioritizes offline functionality, assuming users may want to access recipes without internet connectivity.

4. **User Generated Content**: The app assumes users will want to view recipes. And also create, view, or delete their own recipes.

### Tradeoffs

1. **Mock API vs. Real Backend**: 
   - **Pro**: Simpler development and testing with predictable data
   - **Con**: Doesn't represent real-world network conditions and edge cases

2. **CoreData for Storage**:
   - **Pro**: Robust, built-in solution with relationships support
   - **Con**: Added complexity compared to simpler solutions like UserDefaults

3. **SwiftUI-Only Approach**:
   - **Pro**: Modern, declarative UI with less code
   - **Con**: Some advanced UI customizations might be more challenging

4. **Local Images vs. Remote URLs**:
   - **Pro**: Better offline experience and performance
   - **Con**: Limited scalability for large image collections

5. **MVVM Architecture**:
   - **Pro**: Clear separation of concerns, testability
   - **Con**: More boilerplate code than simpler architectures

## Known Limitations

1. **UI-Only / Placeholder Interactions**:  Some UI elements (e.g., buttons such as *Sign Out*, *Settings*) are currently implemented for presentation and user flow demonstration purposes only. These elements may trigger temporary behaviors (such as toast messages) and do not yet have full underlying functionality. This was done intentionally to make the mini project feel like a complete application.

2. **Authentication**: The app currently lacks user authentication capabilities.

3. **Sharing**: No functionality for sharing recipes with other users.

4. **Advanced Filtering**: Limited filtering capabilities beyond basic dietary attributes.

4. **Recipe Categories**: No support for organizing recipes into categories or collections.

5. **Nutritional Information**: No calculation or display of nutritional values.

6. **Scaling**: Recipe quantities cannot be automatically scaled up or down for different serving sizes.

7. **Shopping Lists**: No integration with shopping lists or ingredient tracking.

8. **External APIs**: No integration with external recipe APIs for expanded content.

9. **Metrics Conversion**: No support for converting between different measurement units.

10. **Real-Time Updates**: No real-time synchronization between devices or users.

## Future Enhancements

- User authentication and profiles
- Cloud synchronization
- Enhanced search with ingredient-based filtering
- Recipe categorization and tagging
- Meal planning functionality
- Shopping list generation from ingredients
- Social features (sharing, commenting, rating)
- Recipe scaling for different serving sizes
- Nutritional information calculation
- Unit and UI Tests

## License

This project is part of a coding challenge and is not licensed for distribution.

© 2026 Kaizz Alain Benipayo Angeles
