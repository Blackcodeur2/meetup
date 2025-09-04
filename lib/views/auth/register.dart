// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/const.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/types/users.dart';
import 'package:meetup/views/auth/login.dart';
import 'package:meetup/views/auth/login_after_signup.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String? gender;
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = '';
  String _selectedPreferences = '';
  final emailController = TextEditingController();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthController authController = AuthController();

  Color accentColor = AppTheme.primaryColor;

  // Erreurs de validation par étape
  String? nomError;
  String? prenomError;
  String? dateError;

  String? genderError;
  String? preferencesError;

  String? emailError;
  String? telephoneError;

  String? passwordError;
  String? confirmPasswordError;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 ans
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 ans
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 ans
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        dateError = null;
      });
    }
  }

  bool _validateStep0() {
    bool valid = true;
    setState(() {
      nomError = nomController.text.trim().isEmpty ? 'Nom requis' : null;
      prenomError = prenomController.text.trim().isEmpty
          ? 'Prénom requis'
          : null;
      dateError = _selectedDate == null ? 'Date de naissance requise' : null;
      if (nomError != null || prenomError != null || dateError != null)
        valid = false;
    });
    return valid;
  }

  bool _validateStep1() {
    bool valid = true;
    setState(() {
      genderError = _selectedGender.isEmpty ? 'Genre requis' : null;
      preferencesError = _selectedPreferences.isEmpty
          ? 'Préférences requises'
          : null;
      if (genderError != null || preferencesError != null) valid = false;
    });
    return valid;
  }

  bool _validateStep2() {
    bool valid = true;
    final email = emailController.text.trim();
    final tel = telephoneController.text.trim();
    setState(() {
      emailError = email.isEmpty
          ? 'Email requis'
          : (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)
                ? 'Email invalide'
                : null);
      telephoneError = tel.isEmpty
          ? 'Téléphone requis'
          : null; // On peut ajouter regex pour téléphone si besoin
      if (emailError != null || telephoneError != null) valid = false;
    });
    return valid;
  }

  bool _validateStep3() {
    bool valid = true;
    final pwd = passwordController.text.trim();
    final confirmPwd = confirmPasswordController.text.trim();
    setState(() {
      passwordError = pwd.isEmpty
          ? 'Mot de passe requis'
          : (pwd.length < 6 ? 'Minimum 6 caractères' : null);
      confirmPasswordError = confirmPwd.isEmpty
          ? 'Confirmation requise'
          : (confirmPwd != pwd
                ? 'Les mots de passe ne correspondent pas'
                : null);
      if (passwordError != null || confirmPasswordError != null) valid = false;
    });
    return valid;
  }

  void _register() async {
    try {
      await authController.signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text,
      );
      print('Inscription réussie');
      print('Création du profil...');
      try {
        final nom = nomController.text.trim();
        final prenom = prenomController.text.trim();
        final email = emailController.text.trim();
        final dateNaissance = _selectedDate.toString();
        final genre = _selectedGender;
        final preference = _selectedPreferences;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginAfterSignUpPage(
              email: email,
              nom: nom,
              prenom: prenom,
              dateNaissance: dateNaissance,
              genre: genre,
              preference: preference,
            ),
          ),
        );
      } catch (e) {
        print('Erreur lors de la création du profil: $e');
      }
    } catch (e) {
      if (mounted) {
        // print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'inscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    // Ici ajoutez la logique d’enregistrement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFB),
      appBar: LoveAppBar(title: "Créer un compte", showLogoutButton: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              background: Color(0xFFFAFAFB),
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            elevation: 0,
            currentStep: _currentStep,
            onStepContinue: () {
              bool canContinue = false;
              switch (_currentStep) {
                case 0:
                  canContinue = _validateStep0();
                  break;
                case 1:
                  canContinue = _validateStep1();
                  break;
                case 2:
                  canContinue = _validateStep2();
                  break;
                case 3:
                  canContinue = _validateStep3();
                  break;
              }
              if (canContinue) {
                if (_currentStep < 3) {
                  setState(() => _currentStep += 1);
                } else {
                  // Soumettre
                  _register();

                  // Optionnel: message succès, navigation, etc.
                }
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accentColor),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                        onPressed: details.onStepCancel,
                        child: Text(
                          "Retour",
                          style: TextStyle(color: accentColor, fontSize: 15),
                        ),
                      ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: StadiumBorder(),
                        elevation: 3,
                        padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == 3 ? "Créer" : "Suivant",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text(
                  "Informations Personnelles",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          hintText: 'Entrez votre nom',
                          prefixIcon: Icon(Icons.person, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 245, 243, 243),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: nomError,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: prenomController,
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          hintText: 'Entrez votre prénom',
                          prefixIcon: Icon(Icons.person, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 245, 243, 243),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: prenomError,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                _selectedDate == null
                                    ? 'Date de naissance'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? const Color.fromARGB(255, 132, 131, 131)
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (dateError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dateError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text(
                  "Profil",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    // Genre
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Genre :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildGenderButton(
                                      icon: Icons.male,
                                      label: 'Homme',
                                      value: 'M',
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildGenderButton(
                                      icon: Icons.female,
                                      label: 'Femme',
                                      value: 'F',
                                    ),
                                  ),
                                ],
                              ),
                              if (genderError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      genderError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Preferences
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Préférences :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPreferencesButton(
                                      icon: Icons.male,
                                      label: 'Homme',
                                      value: 'M',
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildPreferencesButton(
                                      icon: Icons.female,
                                      label: 'Femme',
                                      value: 'F',
                                    ),
                                  ),
                                ],
                              ),
                              if (preferencesError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      preferencesError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Step(
                title: Text(
                  "Contact",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 2,
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Entrez votre email',
                          prefixIcon: Icon(Icons.email, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 244, 242, 242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: emailError,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: telephoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          hintText: 'Entrez votre numéro',
                          prefixIcon: Icon(Icons.phone, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 244, 242, 242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: telephoneError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text(
                  'Sécurité',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 3,
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Entrez votre mot de passe',
                          prefixIcon: Icon(Icons.lock, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 244, 242, 242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: passwordError,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmer',
                          hintText: 'Confirmez votre mot de passe',
                          prefixIcon: Icon(Icons.lock, color: accentColor),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 244, 242, 242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          errorText: confirmPasswordError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await AuthController.googleSignIn();
          if (result!.user != null) {
            // Handle successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            // Handle sign-in error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur de connexion')),
            );
          }
        },
        child: Icon(Icons.login),
      ),*/
    );
  }

  Widget _buildGenderButton({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
          genderError = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesButton({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedPreferences == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPreferences = value;
          preferencesError = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
