# ROADMAP — async_provider_go

A living document that tracks what has been built, what is in progress,
and where the project is heading. Update this file with every meaningful
milestone.

---

## ✅ Phase 1 — Foundation (Completed)

> Goal: Stand up the project skeleton with Clean Architecture and a working
> posts feed backed by mock data.

- [x] Feature-First Clean Architecture folder structure (`domain`, `data`, `presentation`)
- [x] `Post` domain model with `id`, `title`, `body`, `userId`
- [x] `PostRepository` interface (domain contract)
- [x] `PostRepositoryImpl` — mock data source with simulated network delay
- [x] `PostService` — mock service with `fetchPosts()` and `fetchPostById()`
- [x] `PostState` sealed class — `Initial | Loading | Loaded | Error`
- [x] `PostProvider` — `ChangeNotifier` ViewModel with `loadPosts()`
- [x] `PostScreen` — passive view, `switch` expression against all 4 states
- [x] `PostCard` widget — renders title, userId avatar, chevron
- [x] `PostShimmerList` / `PostShimmerItem` — skeleton loader via `shimmer` package
- [x] Dependency injection via `MultiProvider` + `ProxyProvider` in `main.dart`

---

## ✅ Phase 2 — Routing (Completed)

> Goal: Replace `MaterialApp` with a production-grade `GoRouter` setup that
> supports persistent bottom navigation and deep linking.

- [x] `AppRoutes` + `AppRouteNames` constants — no magic strings anywhere
- [x] `GoRouter` with `StatefulShellRoute.indexedStack` for persistent nav
- [x] `ShellScaffold` with `NavigationBar` guard (crashes if < 2 destinations)
- [x] Posts list route — `/posts`
- [x] Posts detail route — `/posts/:id` (nested, bottom bar stays visible)
- [x] `MaterialApp` → `MaterialApp.router` in `main.dart`

---

## ✅ Phase 3 — Post Detail Feature (Completed)

> Goal: Wire the detail screen to real domain data with full state handling.

- [x] `body` field added to `Post` model
- [x] `getPostById(int id)` added to `PostRepository` contract
- [x] `fetchPostById()` implemented in `PostService`
- [x] `PostDetailState` sealed class — `Initial | Loading | Loaded | Error`
- [x] `loadPost(int id)` method added to `PostProvider`
- [x] `PostCard.onTap` navigates via `context.goNamed` with `pathParameters`
- [x] `PostDetailScreen` — `StatefulWidget`, fetches on `initState`, full
- [x] `switch` expression covering all 4 detail states, retry button on error

---

## ✅ Phase 4 — UI Polish (Completed)

> Goal: Make the app feel production-ready visually before touching the backend.

- [x] Extract `AppTheme` into `lib/core/theme/app_theme.dart`
- [x] Wire up `google_fonts` (Inter) across the app via `AppTheme`
- [x] Add dark mode support via `ThemeMode` toggle in `ThemeProvider`
- [x] Standardise error widget into `lib/core/widgets/error_view.dart`
- [x] Add `SnackBar` feedback on error via provider listener in `PostScreen`
- [x] `PostShimmerList` now accepts `itemCount` — count matches real list length via `PostProvider.shimmerCount`
- [x] Shimmer colours adapt to light/dark theme
- [x] Replace `CircularProgressIndicator` in `PostDetailScreen` with `PostDetailShimmer`
- [x] `PostDetailShimmer` layout mirrors the actual detail screen (avatar, title, body lines)
- [x] `PostScreen` converted to `StatefulWidget` to support provider listener pattern
- [x] `ThemeProvider` injected in `main.dart`, consumed via `Consumer` in `MaterialApp.router`

---

## 🔜 Phase 5 — Auth Feature

> Goal: Add login/signup flow with route protection.

- [ ] New feature folder: `lib/features/auth/`
- [ ] `AuthState` sealed class — `Initial | Loading | Authenticated | Unauthenticated | Error`
- [ ] `AuthProvider` with `login()`, `logout()`, `checkSession()` methods
- [ ] `LoginScreen` and `SignupScreen`
- [ ] `GoRouter.redirect` guard — redirect unauthenticated users to `/login`
- [ ] New `StatefulShellBranch` in `app_router.dart` for Profile tab
- [ ] Uncomment Profile `NavigationDestination` in `ShellScaffold`
- [ ] `flutter_secure_storage` for token persistence

---

## 🔜 Phase 6 — Backend Integration

> Goal: Swap mock services for a real backend with zero changes above the data layer.

- [ ] Add `AppConstants` flag — `static const bool useMockData = true`
- [ ] Conditionally inject mock vs real service in `main.dart`
- [ ] Integrate Supabase client
- [ ] Replace `PostService` mock implementations with real API calls
- [ ] Add `Post.fromJson()` factory for JSON deserialization
- [ ] Add `Post.toJson()` for write operations
- [ ] Add local caching layer in `PostRepositoryImpl` (optional)
- [ ] Environment config — `.env` or `--dart-define` for API keys

---

## 🔜 Phase 7 — Testing

> Goal: Confidence to refactor and ship without regressions.

- [ ] Unit tests for `PostProvider` — assert state transitions
- [ ] Unit tests for `PostRepositoryImpl` — mock the service
- [ ] Widget tests for `PostScreen` — test all 4 state renders
- [ ] Widget tests for `PostDetailScreen` — test all 4 detail states
- [ ] Golden tests for `PostCard` and shimmer widgets
- [ ] Integration test for the list → detail navigation flow

---

## Decisions & Notes

| Date | Decision |
|---|---|
| Phase 2 | `NavigationBar` requires ≥ 2 destinations — guarded with `showNav` bool in `ShellScaffold` |
| Phase 3 | Detail state kept inside `PostProvider` (not a separate provider) — one `ProxyProvider` covers the whole feature |
| Phase 3 | Backend strategy agreed: keep mock `PostService` for UI dev, swap only the service when backend is ready — nothing above the data layer changes |