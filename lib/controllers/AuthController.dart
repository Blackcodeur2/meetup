import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  //register avec email et mot de passe
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  //Login avec email et mot de passe
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  //Logout
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
  
  //Recuperer l'utilisateur connecte
  String? getCurrentUserEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}

