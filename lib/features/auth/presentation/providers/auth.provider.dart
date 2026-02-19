import 'dart:async';

import 'package:async_provider_go/features/auth/domain/models/app_user.model.dart';
import 'package:async_provider_go/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter/material.dart';

// ── Auth states ───────────────────────────────────────────────────────────────
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class AuthAuthenticated extends AuthState {
  final AppUser user;
  AuthAuthenticated(this.user);
}

/// ViewModel for the Auth feature.
///
/// Subscribes to [AuthRepository.authStateChanges] on construction so the
/// router's redirect guard re-evaluates whenever auth state changes.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _authSubscription;

  AuthProvider(this._repository) {
    // Supabase emits the current session on subscribe — handles initial check.
    _authSubscription = _repository.authStateChanges.listen((user) {
      _state = user != null ? AuthAuthenticated(user) : AuthUnauthenticated();
      notifyListeners();
    });
  }

  AuthState _state = AuthInitial();
  AuthState get state => _state;

  bool get isAuthenticated => _state is AuthAuthenticated;
  AppUser? get currentUser =>
      _state is AuthAuthenticated ? (_state as AuthAuthenticated).user : null;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _state = AuthLoading();
    notifyListeners();
    try {
      final user = await _repository.login(email: email, password: password);
      _state = AuthAuthenticated(user);
    } catch (e) {
      _state = AuthError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    _state = AuthLoading();
    notifyListeners();
    try {
      final user = await _repository.signup(email: email, password: password);
      _state = AuthAuthenticated(user);
    } catch (e) {
      _state = AuthError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _state = AuthLoading();
    notifyListeners();
    try {
      await _repository.logout();
      _state = AuthUnauthenticated();
    } catch (e) {
      _state = AuthError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}