/// Domain entity for an authenticated user.
/// Pure Dart — zero Supabase SDK imports.
class AppUser {
  final String id;
  final String email;

  const AppUser({
    required this.id,
    required this.email,
  });
}