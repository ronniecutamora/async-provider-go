import 'package:async_provider_go/features/auth/presentation/providers/auth.provider.dart';
import 'package:async_provider_go/features/auth/presentation/screens/login.screen.dart';
import 'package:async_provider_go/features/auth/presentation/screens/profile.screen.dart';
import 'package:async_provider_go/features/auth/presentation/screens/signup.screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/screens/post.screen.dart';
import '../../features/posts/presentation/screens/post_detail.screen.dart';
import 'app_routes.dart';
import 'shell_scaffold.dart';

/// Builds the app [GoRouter].
///
/// Accepts [AuthProvider] as [refreshListenable] so the redirect guard
/// re-evaluates automatically on every auth state change.
/// Call once from [MyApp] and store in state — never recreate on rebuild.
GoRouter buildAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.posts,
    debugLogDiagnostics: true,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final authState = authProvider.state;
      final isInitial = authState is AuthInitial;
      final isLoading = authState is AuthLoading;
      final isAuthenticated = authState is AuthAuthenticated;

      final isOnAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      // Wait for the initial session check to complete before doing anything.
      if (isInitial) return null;

      // Loading on an auth screen means login/signup is in progress — wait.
      // Loading on a protected shell route means logout is in progress —
      // redirect to login immediately so GoRouter doesn't try to pop the
      // shell's last page, which triggers an AssertionError.
      if (isLoading) return isOnAuthRoute ? null : AppRoutes.login;

      // Not authenticated and not already on an auth screen → login.
      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;

      // Authenticated and landed on an auth screen → go to posts.
      if (isAuthenticated && isOnAuthRoute) return AppRoutes.posts;

      return null;
    },
    routes: [
      // ── Auth routes (outside shell — no bottom nav) ──────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // ── Shell (persistent bottom nav) ────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ShellScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // ── Branch 0 : Posts ─────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.posts,
                name: AppRouteNames.posts,
                builder: (context, state) => const PostScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRouteNames.postDetail,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return PostDetailScreen(postId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── Branch 1 : Profile ───────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}