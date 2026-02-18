# Project [async_provider_go]

## Project Overview
A simple Flutter application implementing async programming, provider state management and go_router.
- **State Management:** Provider (Lite Clean Architecture, feature-first approach)
- **Backend:** No backend yet, we fake data via features/posts/data/data_sources/xxxx.service.dart for now

## Core Technology Stack
- **Flutter SDK:** ^3.11.0
- **State Management:** provider: ^6.1.5+1
- **Routing System:** go_router: ^17.1.0
- **Loading Indicators:** shimmer: ^3.0.0
- **Backend:** No backend yet, we fake data via features/posts/data/data_sources/xxxx.service.dart for now
- **UI Components:** Material Design 3

## Database Schema
  No need for now

# Architecture & Project Structure

This project follows a **Feature-First Clean Architecture**. Code is grouped by feature (e.g., `posts`, `auth`) rather than by technical layer. Inside each feature, the code is strictly divided into three distinct layers: **Domain**, **Data**, and **Presentation**.

## 1. Domain Layer (`domain/`)
The core, independent business logic of the feature. It does not know about the UI, the database, or the network.
* **Models (`domain/models/`)**: Pure Dart classes representing the core business entities (e.g., `Post`). 
* **Repositories - Interfaces (`domain/repositories/`)**: Abstract classes (contracts) defining *what* data operations are possible, without implementing *how* they are done.

## 2. Data Layer (`data/`)
Responsible for fetching, sending, and caching data. It implements the contracts defined by the Domain layer.
* **Data Sources / Services (`data/data_sources/`)**: Direct communicators with the outside world (e.g., HTTP clients, Supabase, local SQLite). They perform the raw data fetching.
* **Repositories - Implementations (`data/repositories/`)**: Concrete classes that implement the Domain layer's repository interface. They take raw data from the data sources and map it into Domain Models.

## 3. Presentation Layer (`presentation/`)
Responsible for everything the user sees and interacts with. It only depends on the Domain layer (interfaces and models) and is completely decoupled from the Data layer.
* **Providers (`presentation/providers/`)**: State managers (usually `ChangeNotifier` classes) that hold the UI state (e.g., `PostInitial`, `PostLoading`) and interact with the Domain Repositories to handle user input.
* **Screens (`presentation/screens/`)**: Full-page Widgets. These are strictly **passive**; they listen to Providers and render the UI accordingly, containing zero business logic.
* **Widgets (`presentation/widgets/`)**: Reusable, smaller UI components specific to this feature (e.g., `post_card.widget.dart`, `post_shimmer.widget.dart`).

## Full Directory Structure

lib
├── features
│   └── posts
│       ├── data
│       │   ├── data_sources
│       │   │   └── post.service.dart
│       │   └── repositories
│       │       └── post.repository.dart
│       ├── domain
│       │   ├── models
│       │   │   └── post.model.dart
│       │   └── repositories
│       │       └── post.repository.dart
│       └── presentation
│           ├── providers
│           │   └── post.provider.dart
│           ├── screens
│           │   └── post.screen.dart
│           └── widgets
│               ├── post_card.widget.dart
│               └── post_shimmer.widget.dart
└── main.dart
## Coding Guidelines
- **MVVM Pattern**: Always separate logic from UI. Widgets should only use `Consumer` or `context.watch/read` to interact with View Models.
- **Documentation**: Always add DartDocs (`///`) to public classes and methods.
- **Styling**: Use `const` constructors wherever possible. Use Material Icons.
- **Error Handling**: Catch errors in the View Model and expose them via an error state string or object; do not let exceptions crash the UI.

## Important Commands
- **Run App**: `flutter run`
- **Fix Lint Issues**: `dart fix --apply`
- **Run Tests**: `flutter test`
- **Build Runner (if applicable)**: `dart run build_runner build --delete-conflicting-outputs`

## Maintenance Rules
- **Evolution**: If we decide on a new coding pattern or add a new library, immediately update everything in this markdown `agents.md`.
