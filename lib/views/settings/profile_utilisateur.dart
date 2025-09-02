import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/const.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String sexe;
  final String preference;
  final String email;
  final String profession;
  final String pays;
  final String ville;
  final String bio;

  UserProfilePage({
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.preference,
    required this.email,
    required this.profession,
    required this.pays,
    required this.ville,
    required this.bio,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Uint8List? _profileImage;
  final ImagePicker picker = ImagePicker();
  bool _showCameraIcon = true; // Contrôle affichage icône caméra

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      print('Image sélectionnée : ${image.path}'); // debug
      // Upload dans Supabase
      final imageName =
          'profile_images/${widget.prenom}_${widget.nom}_${DateTime.now().millisecondsSinceEpoch}.png';
      try {
        final response = await supabase.storage
            .from('profilebucket') // Remplacez par votre bucket
            .uploadBinary(
              imageName,
              imageBytes,
              fileOptions: FileOptions(cacheControl: '3600', upsert: true),
            );
        final AuthController authController = AuthController();
        final currentUserId = authController.getCurrentUserId();
        print('ID utilisateur courant : $currentUserId');

        print('Image uploadée avec succès : $response');
        setState(() {
          _profileImage = imageBytes;
          _showCameraIcon = false; // Masquer icône caméra
        });
        final publicUrl = supabase.storage
            .from('profilebucket')
            .getPublicUrl(imageName);
        final r = await supabase
            .from('profile')
            .update({'profile_url': publicUrl})
            .eq('user_id', currentUserId)
            .select();

        print('Update réponse : ${r.length}');

        print('URL publique de l\'image : ${publicUrl}');
      } catch (e) {
        print('Erreur upload image: $e');
      }
    } else {
      print('Aucune image sélectionnée');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LoveAppBar(title: 'My Profile', showLogoutButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  _profileImage != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(_profileImage!),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage('images/avatar.jpg') as ImageProvider,
                          radius: 60,
                        ),
                  if (_showCameraIcon) // Affiche seulement si true
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.indigo[700],
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                '${widget.prenom} ${widget.nom}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Text(
                widget.profession,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            _infoRow(Icons.cake, 'Date de naissance', widget.dateNaissance),
            SizedBox(height: 12),
            _infoRow(Icons.person, 'Sexe', widget.sexe),
            SizedBox(height: 12),
            _infoRow(Icons.favorite, 'Préférence', widget.preference),
            SizedBox(height: 12),
            _infoRow(Icons.email, 'Email', widget.email),
            SizedBox(height: 12),
            _infoRow(Icons.location_on, 'Pays', widget.pays),
            SizedBox(height: 12),
            _infoRow(Icons.location_city, 'Ville', widget.ville),
            SizedBox(height: 12),
            Text(
              'À propos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.bio,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo[700]),
        SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.indigo[700],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            info,
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}