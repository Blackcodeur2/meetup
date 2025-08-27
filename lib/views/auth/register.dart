import 'package:flutter/material.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String? gender;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();

  Color accentColor =
      AppTheme.primaryColor; // Tu peux choisir une couleur vive ici

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
            type: StepperType.horizontal,
            elevation: 0,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                // Soumettre ou continuer
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ), // Pour déplacer les boutons vers le bas
                child: Row(
                  children: [
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
                        _currentStep == 2 ? "Créer" : "Suivant",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(), // espace flexible pour séparer les boutons
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
                  ],
                ),
              );
            },

            steps: [
              Step(
                title: Text(
                  "Infos",
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
                        controller: nameController,
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
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Âge',
                          hintText: 'Entrez votre âge',
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: accentColor,
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 236, 234, 234),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text(
                  "Genre",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1
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
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Genre',
                      prefixIcon: Icon(Icons.wc, color: accentColor),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 239, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: Text('Sélectionnez votre genre'),
                    value: gender,
                    onChanged: (value) => setState(() => gender = value),
                    items: [
                      DropdownMenuItem(value: "Male", child: Text("Homme")),
                      DropdownMenuItem(value: "Female", child: Text("Femme")),
                      DropdownMenuItem(value: "Other", child: Text("Autre")),
                    ],
                  ),
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
                  child: TextField(
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
