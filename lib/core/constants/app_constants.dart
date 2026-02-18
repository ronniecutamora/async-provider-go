/// App-wide constants loaded at compile time via --dart-define.
///
/// To run the app, pass both values in your run command:
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://your-project.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=your-anon-key
/// ```
///
/// For VS Code, add a `.vscode/launch.json` with `toolArgs`.
/// For Android Studio, add them under Run > Edit Configurations > Additional args.
abstract final class AppConstants {
  /// Your Supabase project URL.
  /// Throws a clear error at startup if not provided.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Your Supabase project anon (public) key.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Guards against a missing config at startup rather than failing silently
  /// deep inside a network call.
  static void validate() {
    assert(
      supabaseUrl.isNotEmpty,
      'SUPABASE_URL is not set. Pass it via --dart-define=SUPABASE_URL=...',
    );
    assert(
      supabaseAnonKey.isNotEmpty,
      'SUPABASE_ANON_KEY is not set. Pass it via --dart-define=SUPABASE_ANON_KEY=...',
    );
  }
}