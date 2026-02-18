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
      `switch` expression covering all 4 detail states, retry button on error

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

## 🔜 Phase 5 — Supabase Setup (Next Up)

> Goal: Initialise the Supabase client and wire environment config so every
> feature that follows can talk to a real backend.

- [x] Add `supabase_flutter` to `pubspec.yaml`
- [x] Create `lib/core/constants/app_constants.dart` — store Supabase URL & anon key via `--dart-define`
- [x] Initialise `Supabase.initialize()` in `main.dart` before `runApp`
- [x] Expose `Supabase.instance.client` via a `Provider` in `main.dart` so all features can inject it
- [x] Add `.env.example` and document `--dart-define` setup in README

---

## 🔜 Phase 6 — Auth Feature

> Goal: Full sign-up / login / logout flow backed by Supabase Auth, with
> route protection and persistent session.

- [ ] New feature folder: `lib/features/auth/`
- [ ] `AppUser` domain model — wraps Supabase `User` without leaking the SDK into the domain
- [ ] `AuthRepository` interface (domain contract)
- [ ] `AuthService` — raw Supabase Auth calls (`signInWithPassword`, `signUp`, `signOut`, `onAuthStateChange`)
- [ ] `AuthRepositoryImpl` — depends on `AuthService`, maps results to `AppUser`, handles errors
- [ ] `AuthState` sealed class — `Initial | Loading | Authenticated | Unauthenticated | Error`
- [ ] `AuthProvider` with `login()`, `signup()`, `logout()`, `checkSession()` methods
- [ ] `LoginScreen` with email + password fields and button loading state via `CircularProgressIndicator`
- [ ] `SignupScreen` with email + password + confirm password fields and button loading state
- [ ] `GoRouter.redirect` guard — unauthenticated users redirected to `/login`
- [ ] Listen to `supabase.auth.onAuthStateChange` stream in `AuthProvider`
- [ ] `flutter_secure_storage` for session token persistence
- [ ] Wire DI in `main.dart` — inject `SupabaseClient` → `AuthService` → `AuthRepositoryImpl` → `AuthProvider`
- [ ] New `StatefulShellBranch` in `app_router.dart` for Profile tab
- [ ] Uncomment Profile `NavigationDestination` in `ShellScaffold`
- [ ] `ProfileScreen` — shows logged-in user info and a logout button with `showDialog` confirmation

---

## 🔜 Phase 7 — Migrate Posts to Supabase

> Goal: Replace the mock `PostService` with real Supabase database calls.
> Nothing above the data layer changes.

- [ ] Create `posts` table in Supabase (id, title, body, user_id, created_at)
- [ ] Add `Post.fromJson()` factory for Supabase row deserialization
- [ ] Replace `PostService` mock with real `supabase.from('posts').select()` calls
- [ ] Replace `fetchPostById()` mock with `.eq('id', id)` query
- [ ] Pass `SupabaseClient` into `PostService` via DI in `main.dart`
- [ ] Add Row Level Security (RLS) policies — users can only read published posts
- [ ] Add local caching layer in `PostRepositoryImpl` (optional)

---

## 🔜 Phase 8 — Testing

> Goal: Confidence to refactor and ship without regressions.

- [ ] Unit tests for `AuthProvider` — assert state transitions
- [ ] Unit tests for `PostProvider` — assert state transitions
- [ ] Unit tests for `PostRepositoryImpl` — mock the service
- [ ] Widget tests for `PostScreen` — test all 4 state renders
- [ ] Widget tests for `PostDetailScreen` — test all 4 detail states
- [ ] Widget tests for `LoginScreen` — form validation and error state
- [ ] Golden tests for `PostCard` and shimmer widgets
- [ ] Integration test for login → list → detail navigation flow

---

## Decisions & Notes

| Date | Decision |
|---|---|
| Phase 2 | `NavigationBar` requires ≥ 2 destinations — guarded with `showNav` bool in `ShellScaffold` |
| Phase 3 | Detail state kept inside `PostProvider` (not a separate provider) — one `ProxyProvider` covers the whole feature |
| Phase 3 | Backend strategy agreed: keep mock `PostService` for UI dev, swap only the service when backend is ready — nothing above the data layer changes |
| Phase 5 | Supabase client exposed as a `Provider<SupabaseClient>` in `main.dart` so auth and posts features both inject it cleanly without a service locator |
| Phase 6 | `AppUser` domain model wraps Supabase `User` — keeps the SDK out of the domain and presentation layers |