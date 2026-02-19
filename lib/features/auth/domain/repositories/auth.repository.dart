import '../models/app_user.model.dart';

/// Contract for auth operations.
/// Presentation layer only ever depends on this interface.
abstract class AuthRepository {
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> signup({required String email, required String password});
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Stream<AppUser?> get authStateChanges;
}