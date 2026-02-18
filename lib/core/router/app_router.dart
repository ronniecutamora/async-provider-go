import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/screens/post.screen.dart';
import '../../features/posts/presentation/screens/post_detail.screen.dart';
import 'app_routes.dart';
import 'shell_scaffold.dart';

/// Global [GoRouter] instance.
///
/// - [StatefulShellRoute.indexedStack] preserves each tab's navigation
///   stack and scroll position across tab switches.
/// - All paths and names live in [AppRoutes] / [AppRouteNames].
/// - Add new [StatefulShellBranch]es here when new top-level features arrive.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.posts,
  debugLogDiagnostics: true, // set to false for production
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => ShellScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        // ── Branch 0 : Posts ──────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.posts,
              name: AppRouteNames.posts,
              builder: (context, state) => const PostScreen(),
              routes: [
                GoRoute(
                  path: ':id',          // resolves to /posts/:id
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

        // ── Branch 1 : Profile (uncomment when ready) ─────────────────────
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: AppRoutes.profile,
        //       name: AppRouteNames.profile,
        //       builder: (context, state) => const ProfileScreen(),
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);