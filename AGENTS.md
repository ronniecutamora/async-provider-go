# Project [async_provider_go]

## Project Overview
A production-ready Flutter application implementing asynchronous programming, Provider state management, and GoRouter.
- **State Management:** Provider (Clean Architecture, Feature-First approach).
- **Backend:** Mock Data Services (Ready for Supabase/REST integration).

## Core Technology Stack
- **Flutter SDK:** ^3.11.0
- **State Management:** `provider`
- **Routing:** `go_router` (StatefulShellRoute for persistent nav)
- **UI & UX:** Material Design 3 & `shimmer` for skeleton loaders

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
├── core/                  # Global configs (theme, router, constants)
├── features/
│   └── posts/
│       ├── data/          # Services & Repository Impls
│       ├── domain/        # Models & Repository Interfaces
│       └── presentation/  # Providers, Screens & Widgets
└── main.dart              # Dependency Injection & App Entry
```

## Example Directory Structure
```text
lib/
├── core/                   # Global configs (theme, router, constants)
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
- **State Handling**: Use **Sealed Classes** and **Switch Expressions** for UI states (Initial, Loading, Loaded, Error).

## Example State Handling

```dart
    @override
    Widget build(BuildContext context) {
    final state = context.watch<PostProvider>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("My Blog")),
      body: RefreshIndicator(
        onRefresh: () => context.read<PostProvider>().loadPosts(),
        child: switch (state) {
          PostInitial() => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(child: Text("Pull down to load posts")),
                ),
              ],
            ),
          PostLoading() => const PostShimmerList(), 
          PostError(message: var m) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text(m)),
                ),
              ],
            ),
          PostLoaded(posts: var list) => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), 
              itemCount: list.length,
              itemBuilder: (context, index) => PostCard(post: list[index]),
            ),
        },
      ),
    );
  }
```
- **Immutability**: Use `const` constructors wherever possible.
- **Error Handling**: Use `try/catch` in the Repository implementation; the Provider should convert these into UI-friendly states.

## Maintenance Rules
- **Documentation**: Use `///` (DartDocs) for public-facing logic.
- **Project Blueprint**: Update this file (`README.md`) immediately when adding new global libraries or changing architectural patterns.