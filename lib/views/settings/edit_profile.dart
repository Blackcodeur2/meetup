import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  const EditProfilePage({super.key, required this.userProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController _prenomController;
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _dateNaissanceController;
  late TextEditingController _sexeController;
  late TextEditingController _preferenceController;
  late TextEditingController _paysController;
  late TextEditingController _villeController;
  late TextEditingController _bioController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.userProfile;
    _prenomController = TextEditingController(text: p['prenom'] ?? '');
    _nomController = TextEditingController(text: p['nom'] ?? '');
    _emailController = TextEditingController(text: p['email'] ?? '');
    _telephoneController = TextEditingController(text: p['telephone'] ?? '');
    _dateNaissanceController = TextEditingController(text: p['dateNaissance'] ?? '');
    _sexeController = TextEditingController(text: p['sexe'] ?? '');
    _preferenceController = TextEditingController(text: p['preference'] ?? '');
    _paysController = TextEditingController(text: p['pays'] ?? '');
    _villeController = TextEditingController(text: p['ville'] ?? '');
    _bioController = TextEditingController(text: p['bio'] ?? '');
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final currentUserId = supabase.auth.currentUser!.id;

      await supabase.from("profile").update({
        "prenom": _prenomController.text.trim(),
        "nom": _nomController.text.trim(),
        "email": _emailController.text.trim(),
        "telephone": _telephoneController.text.trim(),
        "date_naissance": _dateNaissanceController.text.trim(),
        "sexe": _sexeController.text.trim(),
        "preference": _preferenceController.text.trim(),
        "pays": _paysController.text.trim(),
        "ville": _villeController.text.trim(),
        "bio": _bioController.text.trim(),
      }).eq("user_id", currentUserId);

      if (mounted) {
        Navigator.pop(context, true); // Retourne au profil avec succès
      }
    } catch (e) {
      print("Erreur update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la mise à jour du profil")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoveAppBar(
        title: "Modifier le profil",
        showLogoutButton: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_prenomController, "Prénom"),
              _buildTextField(_nomController, "Nom"),
              _buildTextField(_emailController, "Email", inputType: TextInputType.emailAddress),
              _buildTextField(_telephoneController, "Téléphone", inputType: TextInputType.phone),
              _buildDateField(),
              _buildTextField(_sexeController, "Sexe"),
              _buildTextField(_preferenceController, "Préférence"),
              _buildTextField(_paysController, "Pays"),
              _buildTextField(_villeController, "Ville"),
              _buildTextField(_bioController, "À propos", maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _updateProfile,
                child: const Text("Enregistrer"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: (value) =>
        value == null || value.isEmpty ? "Veuillez renseigner $label" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _dateNaissanceController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date de naissance",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(_dateNaissanceController.text) ??
                DateTime(2000, 1, 1),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        },
      ),
    );
  }
}
