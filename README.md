# ReciMe Challenge

A modern iOS recipe browsing and creation application built with Swift and SwiftUI.

![ReciMe App](ReciMeChallenge/Assets.xcassets/SplashLogo.imageset/Logo.png)

## Overview

ReciMeChallenge is a feature-rich iOS application that allows users to browse, search, and create cooking recipes. The app provides an intuitive interface for viewing recipe details including title, description, servings, ingredients, cooking instructions, and dietary attributes. 

Initially built to meet basic requirements of browsing mock recipe data from a local JSON file, the app has been enhanced with additional features like recipe creation, image support, persistent storage with Core Data, toast notifications, concurrency handling, and modern UI management.

## Features

- **Recipe Browsing**: Browse through a collection of recipes with a clean, intuitive interface
- **Recipe Details**: View comprehensive recipe information including ingredients, instructions, and dietary attributes
- **Search & Filtering**: Find recipes with text search and multiple filtering options including dietary preferences
- **Recipe Creation**: Create and save your own recipes with custom images
- **Data Persistence**: Core Data integration for local data persistence
- **Image Management**: Support for recipe images with local file storage
- **Toast Notifications**: User-friendly status notifications
- **Modern UI**: Built with SwiftUI for a responsive and modern user experience
- **Concurrency**: Utilizes Swift concurrency features for efficient data handling

## Setup Instructions

### Requirements

- Xcode 14.0+ (recommended: latest version)
- iOS 15.0+ (designed for iOS 16+)
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

No external dependencies are required as the project uses only native Apple frameworks.

## High-Level Architecture Overview

The app follows the MVVM (Model-View-ViewModel) architecture pattern with a repository layer for data management:

### Core Layers

1. **Models**: Define the data structures (Recipe, Ingredient, DietaryAttributes)
2. **Views**: SwiftUI views responsible for UI rendering
3. **ViewModels**: Handle business logic and prepare data for views
4. **Repository**: Coordinates between data sources (local storage and mock API)
5. **Services**: Handle specific functionality like data fetching
6. **Storage**: Manages Core Data operations for data persistence
7. **Utilities**: Helper components like Toast notifications and custom layouts

### Data Flow

1. **UI Layer**: User interacts with SwiftUI views
2. **ViewModels**: Process user actions and update UI state
3. **Repository**: Coordinates data operations between services and storage
4. **Services**: Fetch data from the mock API (local JSON file)
5. **Storage**: Persists data using Core Data

## Project Structure

```
ReciMeChallenge/
├── App/                   # App entry point and lifecycle
├── Assets/                # Images and resources
├── Core/                  # Core business logic
│   ├── Models/            # Data models (Recipe, Ingredient, etc.)
│   ├── Repository/        # Data coordination layer
│   ├── Services/          # Business services (API, mock)
│   ├── Storage/           # Core Data services
│   └── Utility/           # Shared utilities (Toast, Layout)
├── Features/              # UI features organized by domain
│   ├── MainScreens/       # Main app screens
│   │   ├── CreateRecipe/  # Recipe creation
│   │   ├── Dashboard/     # Main dashboard
│   │   ├── Explore/       # Search and explore
│   │   ├── MainContainer/ # Tab container
│   │   ├── MyRecipes/     # User's recipes
│   │   ├── Profile/       # User profile 
│   │   └── RecipeDetail/  # Recipe details
│   └── Shared/            # Shared UI components
└── Resources/             # External resources (JSON data)
```

## Key Design Decisions

### 1. Repository Pattern

The app implements a repository pattern to abstract data sources, making it easy to switch between mock data and real API data. The repository coordinates between:
- Network services for fetching remote data (currently via local JSON file)
- Core Data for local persistence

This provides a single source of truth for recipe data throughout the app and facilitates future extension to real API endpoints.

```swift
protocol RecipeRepositoryProtocol {
    var recipesPublisher: AnyPublisher<[Recipe], Never> { get }
    func sync() async throws
    func addRecipe(_ recipe: Recipe) throws
    func deleteRecipe(_ recipe: Recipe) throws
    func saveImageToDisk(data: Data) throws -> URL?
}
```

### 2. MVVM Architecture

Each feature follows the MVVM pattern for clear separation of concerns:
- **Models**: Plain Swift structs conforming to `Codable` and `Identifiable`
- **Views**: SwiftUI views for UI representation
- **ViewModels**: Observable classes managing UI state and business logic

This separation improves testability and maintainability.

### 3. Protocol-Oriented Design

The app uses protocol-oriented design for flexibility and testability:

```swift
protocol RecipeService {
    func fetchRecipes() async throws -> [Recipe]
}

protocol RecipePersistenceService {
    func saveRecipes(_ recipes: [Recipe]) throws
    func fetchRecipes() -> [Recipe]
    func deleteRecipe(id: String) throws
}
```

This approach allows for easy mocking during testing and seamless swapping of implementations.

### 4. Core Data Integration

Core Data is used for offline persistence with a service layer that abstracts the complexities:

```swift
final class RecipeCoreDataStorage: RecipePersistenceService {
    // Implementation details
}
```

Key Core Data design choices:
- JSON encoding/decoding for complex nested types
- Upsert pattern to handle duplicates
- Error handling with meaningful errors
- Default values for optional properties

### 5. Swift Concurrency

Modern Swift concurrency features (async/await) are used for asynchronous operations:

```swift
func sync() async throws {
    let remote = try await recipeService.fetchRecipes()
    try persistence.saveRecipes(remote)
    self.recipes = persistence.fetchRecipes()
}
```

This provides cleaner, more maintainable code compared to completion handlers.

### 6. Image Handling Strategy

The app implements a dual-mode image handling strategy:
- Remote images via URLs (using placeholder images from picsum.photos)
- Local storage for user-created recipe images

```swift
var resolvedImageURL: URL? {
    guard let originalURL = imageURL else { return nil }
    
    if originalURL.scheme == "http" || originalURL.scheme == "https" {
        return originalURL
    }
    
    // If it's a local file URL, rebuild it to handle Application UUID changes
    let fileName = originalURL.lastPathComponent
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsDirectory.appendingPathComponent(fileName)
}
```

### 7. Toast Notification System

A custom toast notification system provides user feedback:

```swift
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    // Implementation details
}
```

This enhances user experience by providing immediate feedback for actions.

## Assumptions and Tradeoffs

### Assumptions

1. **User Experience Priority**: The app assumes users prefer a visual, image-centric experience when browsing recipes.

2. **Data Volume**: The implementation assumes a moderate number of recipes. For very large datasets, additional optimization like pagination would be needed.

3. **Offline-First Approach**: The app prioritizes offline functionality, assuming users want to access recipes without internet connectivity.

4. **User-Generated Content**: The app assumes users will want to create, view, and manage their own recipes.

5. **Single User Context**: The current implementation assumes a single-user context without authentication requirements.

### Tradeoffs

1. **Mock API vs. Real Backend**: 
   - **Pro**: Simpler development and testing with predictable data
   - **Con**: Doesn't represent real-world network conditions and edge cases

2. **Core Data for Storage**:
   - **Pro**: Robust, built-in solution with relationship support
   - **Con**: Added complexity compared to simpler solutions like UserDefaults
   - **Note**: Selected for its ability to handle complex object relationships and querying capabilities

3. **SwiftUI-Only Approach**:
   - **Pro**: Modern, declarative UI with less code
   - **Con**: Some advanced UI customizations might require more workarounds

4. **Local Images vs. Remote URLs**:
   - **Pro**: Better offline experience and performance
   - **Con**: Limited scalability for large image collections
   - **Decision Rationale**: Hybrid approach implemented to support both use cases

5. **Static vs. Dynamic Dietary Attributes**:
   - **Pro**: Type-safe code with clear implementation
   - **Con**: Less flexibility for adding new dietary categories
   - **Decision Rationale**: Current approach suits the MVP requirements while maintaining type safety

```swift
struct DietaryAttributes: Codable, Hashable {
    let isVegetarian: Bool?
    let isVegan: Bool?
    let isGlutenFree: Bool?
    let isSugarFree: Bool?
}
```

## Known Limitations

1. **Placeholder Images**: Recipe images use random placeholder images from picsum.photos rather than actual food images.

2. **UI-Only Elements**: Some UI elements (e.g., Profile settings, Sign Out button) are implemented for presentation purposes only and trigger toast notifications rather than full functionality.

3. **Authentication**: No user authentication capabilities are implemented.

4. **Data Synchronization**: No cloud synchronization between devices.

5. **Limited Search Capabilities**: While the app supports basic searching and filtering, advanced search features are limited.

6. **Nutritional Information**: No calculation or display of nutritional values.

7. **Recipe Scaling**: Recipe quantities cannot be automatically scaled for different serving sizes.

8. **Validation**: Limited input validation for recipe creation.

9. **Performance Optimization**: The app is optimized for moderate recipe collections; large datasets would require additional optimization.

10. **Testing Coverage**: Limited automated testing implementation.

## Future Enhancement Opportunities

- User authentication and profiles
- Cloud synchronization
- Enhanced search with ingredient-based filtering
- Recipe categorization and tagging
- Meal planning functionality
- Shopping list generation from ingredients
- Social features (sharing, commenting, rating)
- Recipe scaling for different serving sizes
- Nutritional information calculation
- Comprehensive unit and UI tests

## License

This project is part of a coding challenge and is not licensed for distribution.

© 2026 Kaizz Alain Benipayo Angeles
