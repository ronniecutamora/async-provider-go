# 🗺️ Phase: Routing & Global Navigation

This phase focuses on implementing `go_router` using the **StatefulShellRoute** pattern. This ensures that each tab maintains its own state (e.g., scroll position, sub-navigation) when switching.

## 🎯 Objectives
1. **Global Router Setup**: Centralize all navigation logic in `lib/core/router/`.
2. **Persistent Navigation**: Implement a Bottom Navigation Bar that doesn't rebuild screens on every tap.
3. **Refactor Current UI**: Transition `PostScreen` from being a "standalone scaffold" to a "view" inside the main shell.

---

## 🏗️ Technical Architecture
We will use an **IndexedStack** approach via `go_router`. This allows us to keep multiple "Navigators" alive at once.



### Folder Structure Update
```text
lib/
├── core/
│   └── router/
│       ├── app_router.dart      # Main router configuration
│       └── navigation_shell.dart # The UI wrapper (Scaffold + NavigationBar)