/// A clean, user-facing exception used across all features.
///
/// Unlike Dart's built-in [Exception], calling [toString] on this class
/// returns only the [message] — no "Exception:" prefix leaking into the UI.
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}