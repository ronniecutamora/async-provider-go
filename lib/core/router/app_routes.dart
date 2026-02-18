/// Centralised route path & name constants.
///
/// Every route in the app must be declared here so that no magic
/// strings are ever used at the call-site (`context.go(AppRoutes.posts)`).
abstract final class AppRoutes {
  // ── Posts ─────────────────────────────────────────────────────────────────
  static const String posts = '/posts';
  static const String postDetail = '/posts/:id';

  /// Builds the concrete path for a post detail page.
  /// Usage: `context.go(AppRoutes.postDetailPath('42'))`
  static String postDetailPath(String id) => '/posts/$id';
}

/// Named route identifiers — used with [GoRouter.namedLocation].
abstract final class AppRouteNames {
  static const String posts = 'posts';
  static const String postDetail = 'post-detail';
}