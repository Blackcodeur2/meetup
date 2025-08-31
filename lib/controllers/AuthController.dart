// ignore_for_file: file_names

import 'package:meetup/core/const.dart';
import 'package:meetup/types/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  //register avec email et mot de passe
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  //Login avec email et mot de passe
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future createProfile(MyUser user) async {
    await supabase.from('profile').insert({
      'nom': user.nom,
      'prenom': user.prenom,
      'email': user.email,
      'date_naissance': user.dateNaissance,
      'sexe': user.sexe,
      'preference': user.preference,
      'profession': user.profession,
      'pays': user.pays,
      'ville': user.ville,
      'bio': user.bio,
    });
  }

  //Logout
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /*
  ========================= Recuperation des infos du profile utilisateur ============
*/
  //Recuperer  l'email de l'utilisateur connecte
  String? getCurrentUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  //Recuperer  l'id de l'utilisateur connecte
  String getCurrentUserId() {
    final session = supabase.auth.currentSession;
    final user = session?.user;

    return user!.id;
  }

  //Recuperer  Toutes les informations de l'utilisateur connecte

  Future<PostgrestList> getUserInformations() async {
    final user = await supabase.from('profile_utilisateur').select();

    return user;
  }

  final stream = supabase.from('profile').stream(primaryKey: ['id_user'],
  ).map((data) =>data.map((usersMap) => MyUser.fromMap(usersMap)).toList());
}

