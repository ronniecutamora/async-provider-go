import 'package:async_provider_go/core/exceptions/app.exception.dart';
import 'package:async_provider_go/features/auth/data/data_sources/auth.service.dart';
import 'package:async_provider_go/features/auth/data/mappers/auth_error.mapper.dart';
import 'package:async_provider_go/features/auth/domain/models/app_user.model.dart';
import 'package:async_provider_go/features/auth/domain/repositories/auth.repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implements [AuthRepository].
///
/// All Supabase → domain mapping and error handling lives here.
/// Nothing above this layer knows about [AuthResponse] or [User].
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;
  AuthRepositoryImpl(this._service);

  /// Maps a Supabase [User] to our clean domain [AppUser].
  AppUser _toAppUser(User user) => AppUser(
        id: user.id,
        email: user.email ?? '',
      );

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _service.signIn(email: email, password: password);
      final user = response.user;
      if (user == null) throw AppException('No user returned from login.');
      return _toAppUser(user);
    } catch (e) {
      throw AppException(AuthErrorMapper.map(e));
    }
  }

  @override
  Future<AppUser> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _service.signUp(email: email, password: password);
      final user = response.user;
      if (user == null) throw AppException('No user returned from sign up.');
      return _toAppUser(user);
    } catch (e) {
      throw AppException(AuthErrorMapper.map(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _service.signOut();
    } catch (e) {
      throw AppException(AuthErrorMapper.map(e));
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _service.currentUser;
    return user != null ? _toAppUser(user) : null;
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      _service.onAuthStateChange.map((state) {
        final user = state.session?.user;
        return user != null ? _toAppUser(user) : null;
      });
}