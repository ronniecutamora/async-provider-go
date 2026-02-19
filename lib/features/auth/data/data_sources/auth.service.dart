import 'package:supabase_flutter/supabase_flutter.dart';

/// Raw Supabase Auth calls.
///
/// This is the only file in the auth feature that imports the Supabase SDK
/// directly. Nothing above this layer knows about Supabase.
class AuthService {
  final SupabaseClient _client;
  AuthService(this._client);

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) =>
      _client.auth.signUp(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  /// Returns the currently cached user, or null if not authenticated.
  User? get currentUser => _client.auth.currentUser;

  /// Emits on every auth state change. Supabase also emits the current
  /// session on subscription, so this handles the initial session check.
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}