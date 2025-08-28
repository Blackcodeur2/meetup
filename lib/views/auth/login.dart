import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/main.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/views/auth/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMsg;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();

  @override
  void initState() {
    super.initState();
    // Init controllers if needed (already initialized on declaration)
  }
  void _login() async{
    final email = emailController.text.trim();
    final password = passwordController.text;
  try {
   final response = await authController.signUpWithEmailPassword(email, password);
   print(response);
    print('connexion reussie');
  } catch (e) {
   if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
  }}
    
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
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: LoveAppBar(title: "Login", showLogoutButton: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/id/237/200/200',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Bienvenue 👋",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
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
            const SizedBox(height: 8),
            if (errorMsg != null)
              Text(
                errorMsg!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Ajouter la fonctionnalité mot de passe oublié
                },
                child: const Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){_login();},
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
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
