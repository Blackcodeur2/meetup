import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/const.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/main.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/shared/google_btn.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/views/auth/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginAfterSignUpPage extends StatefulWidget {
  final String email;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String genre;
  final String preference;
  const LoginAfterSignUpPage({super.key, required this.email, required this.nom, required this.prenom, required this.dateNaissance, required this.genre, required this.preference});
  @override
  State<LoginAfterSignUpPage> createState() => _LoginAfterSignUpPageState();
}

class _LoginAfterSignUpPageState extends State<LoginAfterSignUpPage> {
  String? errorMsg;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();

  void _showError(String msg) {
    setState(() {
      errorMsg = msg;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          errorMsg = null;
        });
      }
    });
  }

  bool _validateFields() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty) {
      _showError('L\'email est requis');
      return false;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      _showError('Format d\'email invalide');
      return false;
    }
    if (password.isEmpty) {
      _showError('Le mot de passe est requis');
      return false;
    }
    return true;
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    try {
      final response = await authController.signInWithEmailPassword(
        email,
        password,
      );
      final userId = supabase.auth.currentUser!.id;
      print('Utilisateur connecté: $userId');
      //creation du profile

      await supabase.from('profile').insert({
         'nom': widget.nom,
         'prenom' : widget.prenom,
         'email' : widget.email,
         'date_naissance' : widget.dateNaissance,
         'sexe' : widget.genre,
         'preference' : widget.preference,
         'user_id': userId,
         'profession': '',
         'pays': '',
         'ville': '',
         'bio': '',
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      _showError('Erreur lors de la connexion: $e');
    }
  }

  void _validateAndLogin() {
    if (_validateFields()) {
      _login();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: LoveAppBar(title: "Login", showLogoutButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: const [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/avatar.jpg'),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Bienvenue 👋",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorMsg != null)
                    Card(
                      color: Colors.red[50],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMsg!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre email',
                      prefixIcon: Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Ajouter fonctionnalité mot de passe oublié
                      },
                      child: const Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _validateAndLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: SocialAuthBtn(ontap: () {}),
                  ), // pousse les éléments vers le haut si possible
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
