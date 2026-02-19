# PROJECT BLUEPRINT
> **async_provider_go** — Feature Development & Engineering Workflow

This document defines the **standardized workflow** for building and scaling features inside this project. It must be followed strictly to ensure architectural integrity, maintainability, and production readiness.

This project follows:

- Feature-First Clean Architecture
- Provider State Management
- Sealed UI States with Switch Expressions
- DRY-first development philosophy
- Strict Conventional Commits
- Structured commit granularity

---

## ⚙️ Core Principle

> Always build from the inside out:
>
> **Domain → Data → Presentation → Dependency Injection → Tests → Docs**

**Never start with UI.**

---

## 1. Creating a New Feature

### Step 0 — Create Feature Branch

```bash
git checkout -b feature/<feature-name>
```

**Examples:**
- `feature/comments`
- `feature/auth-login`
- `feature/posts-pagination`

---

## 2. Domain Layer *(START HERE)*

**Location:** `lib/features/<feature>/domain/`

**Responsibilities:**
- Define Entities / Models (with `fromJson` if backend integration is needed)
- Define Repository Interfaces
- Add pure business logic
- No Flutter imports
- No HTTP logic
- No UI dependencies

**Required Structure:**
```
domain/
 ├── models/
 └── repositories/
```

**JSON Mapping Rule:**

Models own their own deserialization via `fromJson`. No separate DTOs or mappers needed.

```dart
class Post {
  final int id;
  final String content;
  final DateTime createdAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    content: json['body_text'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
```

**Checklist:**
- [ ] Models created
- [ ] `fromJson` added to model (if backend integration required)
- [ ] Repository interface defined
- [ ] No Flutter imports
- [ ] Domain logic unit tested

**Commit:**
```bash
git add lib/features/<feature>/domain
git commit -m "feat(<feature>): add domain models and repository interface"
```

---

## 3. Data Layer

**Location:** `lib/features/<feature>/data/`

**Responsibilities:**
- Implement repository interface
- Implement service calls
- Parse raw JSON directly into domain models via `Model.fromJson()`
- Handle try/catch
- Throw meaningful exceptions

**Required Structure:**
```
data/
 ├── data_sources/
 └── repositories/
```

**Rules:**
- Repository implements domain interface
- Data layer depends on Domain (never the opposite)
- No UI logic
- No DTOs or separate mappers — models handle their own JSON deserialization

**Checklist:**
- [ ] Service implemented
- [ ] Repository implementation added
- [ ] JSON parsed via `Model.fromJson()` inside the service
- [ ] Repository tested

**Commit:**
```bash
git add lib/features/<feature>/data
git commit -m "feat(<feature>): implement data sources and repository implementation"
```

---

## 4. Presentation Layer

**Location:** `lib/features/<feature>/presentation/`

**Responsibilities:**
- Provider (ViewModel)
- Sealed UI state classes
- Screens (Passive)
- Widgets
- Shimmer loading widgets

**Required Structure:**
```
presentation/
 ├── providers/
 ├── screens/
 └── widgets/
```

### Provider Rules

Must expose sealed state classes:
- `Initial`
- `Loading`
- `Loaded`
- `Error`

Must convert exceptions into UI-safe states. No `BuildContext` in provider. No UI logic inside provider.

### Screen Rules

- Must be passive
- No business logic
- Use `switch` expression for state rendering
- Use shimmer for content loading
- Use `CircularProgressIndicator` for button loading

### Shimmer Rule *(Mandatory)*

**For:** Lists, Feeds, Detail pages

**Must use:**
- Dedicated shimmer widget
- Layout must match final layout
- No `CircularProgressIndicator` for content-heavy layouts

### Button Loading Rule *(Mandatory)*

**For:** Submit, Login, Save, Delete, any async button action

**Must:**
- Replace label with `CircularProgressIndicator`
- Disable button during loading
- Maintain consistent sizing

**Checklist:**
- [ ] Provider implemented with sealed states
- [ ] Screen uses switch expression
- [ ] Shimmer widget added
- [ ] Button loading uses `CircularProgressIndicator`
- [ ] No business logic inside screen

**Commit:**
```bash
git add lib/features/<feature>/presentation
git commit -m "feat(<feature>): add provider, screens and shimmer widgets"
```

---

## 5. Dependency Injection

**Location:** `lib/main.dart`

**Use:** `ProxyProvider` — Service → Repository → Provider injection chain

**Checklist:**
- [ ] Repository wired
- [ ] Provider wired
- [ ] No circular dependencies

**Commit:**
```bash
git add lib/main.dart
git commit -m "feat(core): wire <feature> into dependency injection"
```

---

## 6. DRY Enforcement Rules

Before writing new code, search for similar logic in:
- `core/`
- Shared widgets
- Existing providers

**If 70% similar → Extract shared abstraction.**

Prefer:
- Parameterized widgets
- Composition
- Base classes
- Shared utilities

> Duplication is allowed **only** if abstraction harms readability.

---

## 7. Testing Requirements

- Unit test domain logic
- Unit test repository logic
- Widget test key UI states

**Ensure:**
- Loading renders shimmer
- Error renders error state
- Loaded renders content

**Commit:**
```bash
git add test/features/<feature>
git commit -m "test(<feature>): add unit and widget tests"
```

---

## 8. Documentation & Roadmap

After feature completion:
- Update `ROADMAP.md`
- Toggle tasks `[ ]` → `[x]`
- Add architectural notes if needed
- Never delete completed phases

**Commit:**
```bash
git add ROADMAP.md
git commit -m "docs(roadmap): update progress after <feature> implementation"
```

---

## 9. Lint & Format

Before merging:

```bash
flutter format .
dart analyze
```

If changes:
```bash
git add .
git commit -m "style: format code and resolve lints"
```

---

## 10. Pull Request Rules

- One feature per branch
- CI must pass
- No unrelated commits
- Architecture must be respected
- No pattern changes without justification

---

## ✅ Master Feature Checklist

- [ ] Feature branch created
- [ ] Domain complete
- [ ] Data layer complete
- [ ] Presentation complete
- [ ] Shimmer implemented
- [ ] Button loading implemented correctly
- [ ] DI wired
- [ ] Tests added
- [ ] Roadmap updated
- [ ] Lint passed
- [ ] PR opened

---

## 11. GoRouter Redirect Rules

**Location:** `lib/core/router/app_router.dart`

When using `refreshListenable` with an `AuthProvider`, the redirect guard **must distinguish the user's current route context** before deciding whether to wait or redirect.

### The Problem

A blanket `if (isLoading) return null` crashes the app during logout when the user is inside a `StatefulShellRoute`. GoRouter fires the redirect on every `notifyListeners()`. When logout begins:

1. `AuthLoading` → redirect returns `null` → user stays on the shell ✅
2. `AuthUnauthenticated` → redirect returns `/login` → GoRouter tries to pop the shell's last page before navigating → **crash**:
   ```
   _AssertionError: 'currentConfiguration.isNotEmpty':
   You have popped the last page off of the stack, there are no pages left to show
   ```

### The Fix — Split the loading guard by route context

```dart
// ✅ Correct
if (isInitial) return null;
if (isLoading) return isOnAuthRoute ? null : AppRoutes.login;

// ❌ Never do this — causes StatefulShellRoute pop crash on logout
if (isInitial || isLoading) return null;
```

| State | On auth route (`/login`, `/signup`) | On protected shell route |
|---|---|---|
| `AuthInitial` | `null` — wait | `null` — wait |
| `AuthLoading` | `null` — login/signup in progress | `/login` — logout in progress, redirect immediately |
| `AuthUnauthenticated` | `null` — already here | `/login` |
| `AuthAuthenticated` | `/posts` — go home | `null` |

**Rule:** `isInitial` is the only state that unconditionally waits. `isLoading` always depends on where the user currently is.

---

## 🚫 Architecture Guardrails

**Never:**
- Import Flutter into domain
- Put business logic inside screens
- Use `CircularProgressIndicator` for list loading
- Duplicate providers unnecessarily
- Break sealed state pattern
- Skip switch expressions for UI state rendering
- Create separate DTOs or mapper classes — use `Model.fromJson()` instead

---

## 💡 Philosophy

> Build predictable systems.
> Keep layers isolated.
> Favor clarity over cleverness.
> Enforce DRY.
> Commit small.
> Ship production-grade code only.