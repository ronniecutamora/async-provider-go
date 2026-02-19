import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps [AuthException] to user-friendly messages using stable
/// status codes and error codes instead of brittle string matching.
abstract final class AuthErrorMapper {
  static String map(Object error) {
    if (error is AuthException) {
      return _fromAuthException(error);
    }
    return 'Something went wrong. Please try again.';
  }

  static String _fromAuthException(AuthException e) {
    // Use error code first — most stable, set by Supabase's GoTrue API.
    switch (e.code) {
      case 'invalid_credentials':
        return 'Incorrect email or password.';
      case 'email_not_confirmed':
        return 'Please verify your email before logging in.';
      case 'user_already_exists':
      case 'email_exists':
        return 'An account with this email already exists.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Too many attempts. Please wait and try again.';
      case 'weak_password':
        return 'Password must be at least 6 characters.';
      case 'session_not_found':
      case 'refresh_token_not_found':
        return 'Your session has expired. Please log in again.';
    }

    // Fall back to HTTP status code — still more stable than message strings.
    switch (e.statusCode) {
      case '400':
        return 'Incorrect email or password.';
      case '422':
        return 'Invalid email address.';
      case '429':
        return 'Too many attempts. Please wait and try again.';
      case '500':
        return 'Server error. Please try again later.';
    }

    return 'Authentication error. Please try again.';
  }
}