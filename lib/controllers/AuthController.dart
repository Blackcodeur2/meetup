// ignore_for_file: file_names

import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

  /*static Future<AuthResponse?> googleSignIn() async {
    const webClientId =
        '241851830615-moce3f8lhttre933mfr9cnqi1bevseps.apps.googleusercontent.com';
    final googleSignIn = GoogleSignIn.instance;
    // Initialize with serverClientId
    await googleSignIn.initialize(
      serverClientId: webClientId,
      clientId: webClientId,
    );
    // Use authenticate instead of signIn
    final googleUser = await googleSignIn.authenticate(scopeHint: ['email', 'profile'],);

    if (googleUser == null) {
      // L'utilisateur a annulé la connexion
      return null;
    }
     final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }*/

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

  /// Récupérer le profil de l'utilisateur connecté
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    // Étape 1: Récupérer l'utilisateur connecté
    final user = supabase.auth.currentUser;
    if (user == null) {
      return null; // Aucun utilisateur connecté
    }

    // Étape 2: Récupérer les données du profil lié à cet utilisateur
    final response = await supabase
        .from('profile')
        .select()
        .eq('user_id', user.id)
        .single();

    // Étape 3: Retourner les données du profil
    return response;
  }

  /// Récupère tous les utilisateurs sauf l'utilisateur connecté
  Future<List<Map<String, dynamic>>> getAllUsersExceptCurrent() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      return [];
    }

    final response = await supabase
        .from('profile')
        .select()
        .neq('user_id', currentUser.id); // exclure l’utilisateur connecté

    return response;
  }

  //Logout
  static Future<void> signOut() async {
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
  static String? getCurrentUserId() {
  final session = supabase.auth.currentSession;
  final user = session?.user;

  if (user == null) {
    // Gestion quand aucun user connecté (ex: retourner null ou une chaîne vide)
    return null; // ou return '';
  }

  return user.id;
}


  //Recuperer  Toutes les informations de l'utilisateur connecte

  Future<PostgrestList> getUserInformations() async {
    final user = await supabase.from('profile_utilisateur').select();

    return user;
  }

  final stream = supabase
      .from('profile')
      .stream(primaryKey: ['id_user'])
      .map((data) => data.map((usersMap) => MyUser.fromMap(usersMap)).toList());

  //liste de tous les utilisateurs

  static Future<List<MyUser>> listUsers() async {
    List<MyUser> utilisateurs = [];

    try {
      var data = await supabase.from('profile').select();
      for (var user in data) {
        utilisateurs.add(MyUser.fromMap(user));
      }
    } on PostgrestException catch (e) {
      print('Erreur -- ${e.message}');
    }

    return utilisateurs;
  }

  static updateUser(MyUser user) async {
    final id_user = supabase.auth.currentUser!.id;
    try {
      await supabase
          .from('profile')
          .update(user.toMap())
          .eq('id_user', id_user);
    } on PostgrestException catch (e) {
      print('Erreur -- ${e.message}');
    }
  }

  static uploadProfileImage({required String chemin}) async {
    File image = File(chemin);
    try {
      await supabase.storage.from('pp').upload('public/profile.png', image);
      print('Image uploadee avec succes');
    } on StorageException catch (e) {
      print('Erreur ---- ${e.message}');
    }
  }

  static bucketOperation() async {
    try {
      await supabase.storage.createBucket('pp');
      print('OK');
    } on StorageException catch (e) {
      print('Erreur --- ${e.message}');
    }
  }

  recupererImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return await image.readAsBytes();
    } else {
      return null;
    }
  }
}
