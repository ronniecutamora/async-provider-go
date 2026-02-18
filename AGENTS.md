# Project [async_provider_go]

## Project Overview
A production-ready Flutter application implementing asynchronous programming, Provider state management, and GoRouter.
- **State Management:** Provider (Clean Architecture, Feature-First approach).
- **Backend:** Mock Data Services (Ready for Supabase/REST integration).

## Core Technology Stack
- **Flutter SDK:** ^3.11.0
- **State Management:** `provider`
- **Routing:** `go_router` (StatefulShellRoute for persistent nav)
- **UI & UX:** Material Design 3 & `shimmer` for skeleton loaders, `google_fonts`.

# Architecture & Project Structure

This project follows a **Feature-First Clean Architecture**. Code is grouped by feature (e.g., `posts`, `auth`) rather than by technical layer. Each feature is divided into three layers:



### 1. Domain Layer (`domain/`)
The "Source of Truth." Contains business logic, entities, and repository interfaces. **No Flutter dependencies here.**

### 2. Data Layer (`data/`)
The "Infrastructure." Implements repository interfaces and handles raw data fetching from services/APIs.

### 3. Presentation Layer (`presentation/`)
The "UI." Contains Providers (View Models), Screens, and Widgets. This layer only knows about the **Domain**.



## Directory Structure

```text
lib/
├── core/                   # Global configs (theme, router, constants)
│   ├──theme/               # AppTheme & Color Schemes 
│   ├──router/              # GoRouter configuration 
│   └──constants/           # API Keys, Strings, Asset paths       
├── features/               
│   └── posts/
│       ├── data/          # Services & Repository Impls
│       ├── domain/        # Models & Repository Interfaces
│       └── presentation/  # Providers, Screens & Widgets
└── main.dart              # Dependency Injection & App Entry
```
├──theme/                   # AppTheme & Color Schemes 
│   ├──router/              # GoRouter configuration 
│   └──constants/           # API Keys, Strings, Asset paths

## Example Directory Structure

```text
lib/
├── core/                   # Global configs (theme, router, constants)
│   ├──theme/               # AppTheme & Color Schemes 
│   ├──router/              # GoRouter configuration 
│   └──constants/           # API Keys, Strings, Asset paths
├── features
│   └── posts
│       ├── data            # Services & Repository Impls
│       │   ├── data_sources
│       │   │   └── post.service.dart
│       │   └── repositories
│       │       └── post.repository.dart
│       ├── domain          # Models & Repository Interfaces
│       │   ├── models
│       │   │   └── post.model.dart
│       │   └── repositories
│       │       └── post.repository.dart
│       └── presentation    # Providers, Screens & Widgets
│           ├── providers
│           │   └── post.provider.dart
│           ├── screens
│           │   └── post.screen.dart
│           └── widgets
│               ├── post_card.widget.dart
│               └── post_shimmer.widget.dart
└── main.dart               # Dependency Injection & App Entry
```

## Coding Guidelines
- **Logic Separation**: Screens must be passive. All logic stays in the `Provider`.
- **State Handling**: Use **Sealed Classes** and **Switch Expressions** for UI states (Initial, Loading, Loaded, Error). All UI screens must use a `switch` expression against the Provider's state. This ensures 100% of states (Initial, Loading, Error, Success) are handled.

## Example State Handling

```dart
  // Standard UI Pattern
  child: switch (state) {
    PostInitial() => const InitialWidget(),
    PostLoading() => const PostShimmerList(), 
    PostError(message: var m) => ErrorWidget(message: m),
    PostLoaded(posts: var list) => PostListView(posts: list),
  }
```
- **Immutability**: Use `const` constructors wherever possible.
- **Error Handling**: Use `try/catch` in the Repository implementation; the Provider should convert these into UI-friendly states.

### UI Feedback (Alerts & Snackbars)
- **Informational/Errors:** Use `ScaffoldMessenger.of(context).showSnackBar`.
- **Critical Actions:** Use `showDialog` for destructive actions (e.g., Deleting a post, Logout etc).
- **Best Practice:** Keep Snackbar logic inside the `Screen`, triggered by a "Listen" in the build method or via a dedicated UI service.

### Logic Separation 
- **Passive Views:** Screens should contain **no** logic. They only call methods from the Provider.
- **Dependency Injection:** Use `ProxyProvider` in `main.dart` to inject Services into Repositories, and Repositories into Providers.

## Maintenance Rules
- **Documentation**: Use `///` (DartDocs) for public-facing logic.
- **Project Blueprint**: Update this file (`README.md`) immediately when adding new global libraries or changing architectural patterns.