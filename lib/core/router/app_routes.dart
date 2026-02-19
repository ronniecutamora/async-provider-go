/// Centralised route path & name constants.
/// No magic strings anywhere in the app.
abstract final class AppRoutes {
  // ── Posts ──────────────────────────────────────────────────────────────────
  static const String posts = '/posts';
  static const String postDetail = '/posts/:id';
  static String postDetailPath(String id) => '/posts/$id';

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String login = '/login';
  static const String signup = '/signup';

  // ── Profile ────────────────────────────────────────────────────────────────
  static const String profile = '/profile';
}

/// Named route identifiers — used with [GoRouter.namedLocation].
abstract final class AppRouteNames {
  static const String posts = 'posts';
  static const String postDetail = 'post-detail';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String profile = 'profile';
}